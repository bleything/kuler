class Kuler
  class Swatch

    attr_accessor :hex_code

    ### create a new Kuler::Swatch from a Nokogiri::XML::Element
    def initialize( input )
      hex = input.at( "./kuler:swatchHexColor" ).text
      @hex_code = "##{hex.downcase}"
    end

  end

end # class Kuler
