require "test/unit"
require 'pathname'

require "kuler"

class TestKulerTheme < Test::Unit::TestCase
  FIXTURES = Pathname.new( File.dirname(__FILE__) ).expand_path + "fixtures"

  def setup
    xml = FIXTURES + "single_random_result.xml"
    nodes = Nokogiri::XML( xml.read ).at( "//kuler:themeItem" )
    @theme = Kuler::Theme.new( nodes )
  end

  ########################################################################
  ### Basics

  def test_create
    assert_equal 15325, @theme.theme_id
    assert_equal "sandy stone beach ocean diver", @theme.title
    assert_equal %w( beach diver ocean sandy stone ), @theme.tags
    assert_equal 4, @theme.rating

    assert_equal "ps", @theme.author_name
    assert_equal 17923, @theme.author_id

    assert_equal 5, @theme.swatches.size
    @theme.swatches.each do |swatch|
      assert_kind_of Kuler::Swatch, swatch
    end
  end

  def test_hex_codes
    expected = [
      "#e6e2af",
      "#a7a37e",
      "#efecca",
      "#046380",
      "#002f2f"
    ]

    assert_equal expected, @theme.hex_codes
  end


end
