# dependencies
require 'nokogiri'

class Kuler::Theme

  attr_accessor :theme_id, :title, :tags, :rating, :author_name,
                :author_id, :swatches

  ### create a new Kuler::Theme from a Nokogiri::XML::Element
  def initialize( input )
    @theme_id    = input.at( "//kuler:themeID"     ).text.to_i
    @title       = input.at( "//kuler:themeTitle"  ).text
    @tags        = input.at( "//kuler:themeTags"   ).text.gsub(/\s/, '').split(',')
    @rating      = input.at( "//kuler:themeRating" ).text.to_i

    @author_name = input.at( "//kuler:themeAuthor/kuler:authorLabel" ).text
    @author_id   = input.at( "//kuler:themeAuthor/kuler:authorID"    ).text.to_i

    @swatches = input.search( "//kuler:swatch" ).map {|f| f }
  end

end
