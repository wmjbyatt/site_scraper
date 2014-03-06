require_relative 'helper'

class PageScraperTest < MiniTest::Test
  def setup
    @good_page = PageScraper.new('http://simpleenergy.com/')
  end

  def test_that_good_page_get_succeeds
    assert @good_page
  end

  def test_that_bad_page_fails
    assert_raises(PageScraper::BadPageError) { PageScraper.new 'http://simpleenergy.com/somepagethatisntreal' }
  end

  def test_that_contains_method_succeeds
    assert @good_page.contains? /Simple Energy/
    refute @good_page.contains? /I am a rabid hippopotamus/
  end

  def test_that_body_getter_works
    assert @good_page.body
  end

  def test_that_references_scrape
    refute_empty @good_page.references
  end


end