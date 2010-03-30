require "test/unit"
require 'mocha'
require 'pathname'

require "kuler"

FIXTURES = Pathname.new( File.dirname(__FILE__) ).expand_path + "fixtures"

class TestKulerSwatch < Test::Unit::TestCase

  def setup
    xml = FIXTURES + "single_random_result.xml"
    nodes = Nokogiri::XML( xml.read ).at( "//kuler:swatch" )
    @swatch = Kuler::Swatch.new( nodes )
  end

  ########################################################################
  ### Basics

  def test_create
    assert_equal "#e6e2af", @swatch.hex_code
  end

end
