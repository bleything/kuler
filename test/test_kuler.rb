require "test/unit"
require 'mocha'
require 'pathname'

require "kuler"

FIXTURES = Pathname.new( File.dirname(__FILE__) ).expand_path + "fixtures"

class TestKuler < Test::Unit::TestCase
  API_KEY = "test_api_key"

  def setup
    @kuler = Kuler.new( API_KEY )
  end

  ########################################################################
  ### Basics

  def test_setting_api_key_on_initialize
    sample_key = '123456'

    kuler = Kuler.new( sample_key )
    assert_equal sample_key, kuler.api_key, "api key does not match"
  end

  def test_setting_api_key_after_creation
    sample_key = '654321'

    kuler = Kuler.new
    kuler.api_key = sample_key
    assert_equal sample_key, kuler.api_key, "api key does not match"
  end

  ########################################################################
  ### feed url generation

  def test_url_builder
    expected = "http://kuler-api.adobe.com/rss/get.cfm?itemsPerPage=20&key=#{API_KEY}&listType=recent"
    actual = @kuler.build_url

    assert_equal expected, actual, "feed url incorrectly generated"
  end

  def test_url_builder_with_options
    expected = "http://kuler-api.adobe.com/rss/get.cfm?itemsPerPage=100&key=#{API_KEY}&listType=random"

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

    # invalid counts
    assert_raise ArgumentError do
      @kuler.build_url :limit => 0
    end

    assert_raise ArgumentError do
      @kuler.build_url :limit => 101
    end

    assert_nothing_raised do
      @kuler.build_url :limit => 1
      @kuler.build_url :limit => 50
      @kuler.build_url :limit => 100
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
