load './lib/site_scraper.rb'

def run!
  target = "457b4c66887cf81d30728f7ef3be6c49"

  scraper = SiteScraper.new("http://simpleenergy.com")

  puts "Searching SimpleEnergy.com for #{target}"

  location = scraper.seek_string(target)

  puts "String found on #{location}"
end

# Run if executed from command-line. This lets us use the same file to execute or to require for unit tests.
run! if __FILE__ == $0
