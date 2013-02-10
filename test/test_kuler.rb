require "test/unit"
require 'mocha'
require 'pathname'

require "kuler"

class TestKuler < Test::Unit::TestCase
  API_KEY  = "test_api_key"
  FIXTURES = Pathname.new( File.dirname(__FILE__) ).expand_path + "fixtures"

  def setup
    @kuler = Kuler.new( API_KEY )
  end

  ########################################################################
  ### Basics

  def test_creation
    sample_key = '123456'

    kuler = Kuler.new( sample_key )
    assert_equal sample_key, kuler.api_key, "api key does not match"
  end

  ########################################################################
  ### feed url generation

  def test_url_builder
    expected = "https://kuler-api.adobe.com/rss/get.cfm?itemsPerPage=20&key=#{API_KEY}&listType=recent"
    actual = @kuler.build_url

    assert_equal expected, actual, "feed url incorrectly generated"
  end

  def test_url_builder_with_options
    expected = "https://kuler-api.adobe.com/rss/get.cfm?itemsPerPage=100&key=#{API_KEY}&listType=random"

    actual = @kuler.build_url( :type => :random, :limit => 100 )
    assert_equal expected, actual
  end

  def test_url_builder_argument_checking
    # unknown feed type
    assert_raise ArgumentError do
      @kuler.build_url :type => :foo
    end

    assert_nothing_raised do
      @kuler.build_url :type => :recent
    end

    assert_nothing_raised do
      @kuler.build_url :limit => 0
      @kuler.build_url :limit => 1
      @kuler.build_url :limit => 50
      @kuler.build_url :limit => 100
      @kuler.build_url :limit => 101
    end

  end

  ########################################################################
  ### feed url generation

  def test_fetch_random_theme
    url = @kuler.build_url( :type => :random, :limit => 1 )
    xml = FIXTURES + "single_random_result.xml"
    @kuler.expects( :open ).with( url ).returns( xml.read )

    theme = @kuler.fetch_random_theme
    assert_kind_of Kuler::Theme, theme
  end


end
