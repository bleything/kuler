class Kuler
  class Theme

    ### the Kuler ID for the theme
    attr_reader :theme_id

    ### the title of the theme
    attr_reader :title

    ### array of tags attached to this theme
    attr_reader :tags

    ### theme rating, 1-5
    attr_reader :rating

    ### the display name of the theme's creator
    attr_reader :author_name

    ### the Kuler ID for the theme's creator
    attr_reader :author_id

    ### an array of Kuler::Swatch objects representing the colors in
    ### this theme
    attr_reader :swatches


    ### create a new Kuler::Theme from a Nokogiri::XML::Element
    def initialize( input )
      @theme_id    = input.at( "//kuler:themeID"     ).text.to_i
      @title       = input.at( "//kuler:themeTitle"  ).text
      @tags        = input.at( "//kuler:themeTags"   ).text.gsub(/\s/, '').split(',')
      @rating      = input.at( "//kuler:themeRating" ).text.to_i

      @author_name = input.at( "//kuler:themeAuthor/kuler:authorLabel" ).text
      @author_id   = input.at( "//kuler:themeAuthor/kuler:authorID"    ).text.to_i

      @swatches = input.search( "//kuler:swatch" ).map {|nodes| Kuler::Swatch.new nodes }
    end


    ### returns an array of hex values of the swatches in this theme
    def hex_codes
      self.swatches.map {|s| s.hex_code }
    end

  end

end # class Kuler
