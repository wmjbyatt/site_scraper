load './lib/page_scraper.rb'

class SiteScraper

  StringNotFound = Class.new(StandardError)


  def initialize(domain)
    @domain = domain
  end

  def seek_string(string)
    @page_list = ["#{@domain}/"]

    while @page_list.length > 0
      resource = @page_list.shift

      begin
        page = self.fetch_page(resource)
      rescue
        puts "Response not 200 on #{resource}"
      end

      if page.contains? string
        return resource
      else
        self.update_page_list!(page.references)
      end
    end

    raise StringNotFound

  end


  protected

  def fetch_page(resource)
    PageScraper.new(resource)
  end

  def update_page_list!(list)
    @page_list = @page_list.concat(list)

    @page_list.delete_if do |page|
      !page.match(@domain)
    end

    @page_list.uniq!
  end

end