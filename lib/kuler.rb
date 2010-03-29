class Kuler

  ### Library version
  VERSION = '0.1.0'

  ### Kuler API base URL
  BASE_URL = "http://kuler-api.adobe.com"

  ### the key required to access the kuler API
  attr_accessor :api_key

  ### Create a new Kuler object. Accepts a single argument, the
  ### +api_key+.
  def initialize( api_key = nil )
    @api_key = api_key
  end

  ### Build the appropriate URL for a request to the Kuler API.
  ###
  ### Parameters:
  ### +feed_type+:: the type of API call to make. Options are +recent+,
  ###               +popular+, +rating+, or +random+.
  ### +limit+::     the number of schemes to return. Valid range is
  ###               1 to 100.
  def build_url( args = {} )
    # default options
    opts = {
      :feed_type => :recent,
      :limit     => 20
    }.merge( args )

    unless [ :recent, :popular, :rating, :random ].include? opts[:feed_type]
      raise ArgumentError, "unknown feed_type"
    end

    unless (1..100).include? opts[:limit]
      raise ArgumentError, "invalid limit"
    end

    options = {
      :key          => self.api_key,

      :itemsPerPage => opts[:limit],
      :listType     => opts[:feed_type],
    }

    get_args = options.
      sort_by {|k,v| k.to_s }.
      map     {|k,v| "#{k}=#{v}" }.
      join( "&" )

    return "#{BASE_URL}/rss/get.cfm?#{get_args}"
  end

end
