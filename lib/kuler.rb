require 'nokogiri'
require 'open-uri'

require 'kuler/swatch'
require 'kuler/theme'

class Kuler
  VERSION = '0.1.0' # Kuler Version
  API_URL = "https://kuler-api.adobe.com/rss/get.cfm?%s"

  ### the key required to access the kuler API
  attr_reader :api_key

  ### Create a new Kuler object. Accepts a single argument, the
  ### +api_key+.
  def initialize( api_key )
    @api_key = api_key
  end

  ### Build the appropriate URL for a request to the Kuler API.
  ###
  ### Parameters:
  ### +type+::  the type of API call to make. Options are +recent+,
  ###           +popular+, +rating+, or +random+.
  ### +limit+:: the number of themes to return. Valid range is 1 to 100.
  ###           Numbers outside this range will be capped to those limits.
  def build_url(opts = {})
    # default options
    opts = {
      :type  => :recent,
      :limit => 20
    }.merge(opts)

    unless [ :recent, :popular, :rating, :random ].include? opts[:type]
      raise ArgumentError, "unknown feed type '#{opts[:type]}'. Valid options are recent, popular, rating, or random"
    end

    opts[:limit] = [1,   (opts[:limit] || 1).to_i  ].max
    opts[:limit] = [100, (opts[:limit] || 100).to_i].min

    options = {
      :key          => self.api_key,
      :itemsPerPage => opts[:limit],
      :listType     => opts[:type],
    }

    get_args = options.
      delete_if {|_,v| v.nil? }.
      sort_by   {|k,_| k.to_s }.
      map       {|k,v| "#{k}=#{v}" }.
      join("&")

    return API_URL % get_args
  end

  ### fetch a single random color theme
  def fetch_random_theme
    url = build_url( :type => :random, :limit => 1 )
    xml = Nokogiri::XML( open(url) ).at( "//kuler:themeItem" )
    return Kuler::Theme.new( xml )
  end
end
