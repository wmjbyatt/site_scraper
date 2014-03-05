require_relative 'helper'

class SiteScraperTest < MiniTest::Test
  def setup
    @site_scraper = SiteScraper.new 'http://simpleenergy.com'
  end
end