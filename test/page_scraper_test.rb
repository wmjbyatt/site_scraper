require_relative 'helper'

class PageScraperTest < MiniTest::Test
  def setup
    @good_page = PageScraper.new('http://simpleenergy.com/')
  end

  def test_that_good_page_get_succeeds
    refute_nil @good_page
  end

  def test_that_bad_page_fails
    assert_raises(PageScraper::BadPageError) { PageScraper.new 'http://simpleenergy.com/somepagethatisntreal' }
  end

  def test_that_contains_method_succeeds
    refute_nil @good_page.contains? /Simple Energy/
  end


end