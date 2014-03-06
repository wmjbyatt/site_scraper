require_relative 'helper'

class SiteScraperTest < MiniTest::Test
  def setup
    @site_scraper = SiteScraper.new 'http://simpleenergy.com'
  end

  # Unit tests for public methods
  def test_that_search_succeeds
    assert @site_scraper.seek_string "Simple Energy"
  end
end