require 'nokogiri'
require 'open-uri'

require 'kuler/swatch'
require 'kuler/theme'

class Kuler
  # Kuler Version (SemVer)
  VERSION = '0.2.0'

  # API URL template
  API_URL = "https://kuler-api.adobe.com/rss/get.cfm?%s"

  ### the key required to access the kuler API
  attr_reader :api_key

  ### Create a new Kuler object. Accepts a single argument, the +api_key+.
  ### If none provided, the KULER_API_KEY environment variable is used.
  def initialize(api_key=nil)
    @api_key = api_key || ENV['KULER_API_KEY'] || raise(ArgumentError, 'no API key found')
  end

  ### Build the appropriate URL for a request to the Kuler API.
  ###
  ### Options:
  ### +type+::  the type of API call to make. Options are +recent+ (default
  ###           if not given), +popular+, +rating+, or +random+.
  ### +limit+:: the number of themes to return. Valid range is 1 to 100.
  ###           Numbers outside this range will be capped to those limits.
  ###           Defaults to 20.
  def build_url(options = {})
    o = {
      :type   => :recent,
      :limit  => 20,
      :offset => 0
    }.merge(options)

    unless [ :recent, :popular, :rating, :random ].include? o[:type]
      raise ArgumentError, "unknown feed type '#{o[:type]}'. Valid options are recent, popular, rating, or random"
    end

    o[:limit]   = [(o[:limit] || 1).to_i, 1].max
    o[:limit]   = [100, (o[:limit] || 100).to_i].min
    o[:offset]  = [(o[:offset] || 0).to_i, 0 ].max

    # tranlate english keys to Adobe API keyword english
    options = {
      :key          => self.api_key,
      :itemsPerPage => o[:limit],
      :listType     => o[:type],
      :startIndex   => o[:offset]
    }

    get_args = options.
      delete_if {|_,v| v.nil? }.
      sort_by   {|k,_| k.to_s }.
      map       {|k,v| "#{k}=#{v}" }.
      join("&")

    return API_URL % get_args
  end

  ### Fetch a single random color theme. Returns a single Kuler::Theme
  def fetch_random_theme
    fetch_themes(:type => :random, :limit => 1).first
  end

  ### Searches and fetches a set of themes filtered by the given arguments.
  ###
  ### Valid +options+ and their default values are defined through
  ### Kuler.build_url. Return an array of Kuler::Theme items.
  def fetch_themes(options={})
    url = build_url options
    themes = Nokogiri::XML(open(url)).xpath('//item').map do |item|
      Kuler::Theme.new item.at('//kuler:themeItem')
    end

    themes
  end
end
