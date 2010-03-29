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

  ### Given a +feed_type+, generate the appropriate feed url
  def build_url( feed_type = :recent )
    options = {
      :key          => self.api_key,
      :listType     => feed_type,
    }

    get_args = options.
      sort_by {|k,v| k.to_s }.
      map     {|k,v| "#{k}=#{v}" }.
      join( "&" )

    return "#{BASE_URL}/rss/get.cfm?#{get_args}"
  end

end
