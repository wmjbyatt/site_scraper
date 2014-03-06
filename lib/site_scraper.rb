load './lib/page_scraper.rb'

class SiteScraper

  RESOURCE_MATCH_PATTERNS = [
    /^https?:\/\//
  ]

  RESOURCE_IGNORE_PATTERNS = [
    /\.png$/,
    /\.jpg$/,
  ]

  def initialize(domain)
    @domain = domain

    @instance_match_patterns = RESOURCE_MATCH_PATTERNS << /#{@domain}/
    @instance_ignore_patterns = RESOURCE_IGNORE_PATTERNS

    @already_searched = Array.new
    @still_to_search = ["#{@domain}/"]
  end

  def seek_string(string)
    while @still_to_search.length > 0
      resource = @still_to_search.shift

      @already_searched << resource

      # Just ignore anything other than a 200 response
      begin
        page = self.fetch_page(resource)
      rescue PageScraper::BadPageError
        next
      end

      return resource if page.contains? string

      self.update_search_list!(page.references)
    end

    return false
  end

  protected

  def fetch_page(resource)
    PageScraper.new(resource)
  end

  def update_search_list!(list)
    list.each do |resource|
      # Ruby does not provide a way to break or next multiple levels of loop except by using what amounts to a
      # goto call. I prefer flagging for this with the slight added overhead of a few unnecessary tests.

      break_flag = false

      @instance_match_patterns.each do |pattern|
        unless pattern.match resource
          break_flag = true
          break
        end
      end

      @instance_ignore_patterns.each do |pattern|
        if pattern.match resource
          break_flag = true
          break
        end
      end

      # If any of our tests failed, we can skip the add
      next if break_flag

      self.add_to_search_list!(resource)
    end
  end

  # We don't want to bother adding duplicate items to the search list or scanning pages we've already
  # scanned
  def add_to_search_list!(resource)

    unless @already_searched.include?(resource) || @still_to_search.include?(resource)
      @still_to_search << resource
    end


  end

end