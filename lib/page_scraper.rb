require 'net/http'

class PageScraper

  TAG_REGEX = /(<[^\/][^<]*>)/
  RESOURCE_REGEX = /(src|href)=[\'\"]([^\s>]+)[\'\"]/

  BadPageError = Class.new(StandardError)

  def initialize(uri)
    @uri = URI(uri)

    @response = self.get_page
  end

  def body
    @response
  end

  def error
    @error
  end

  def references
    @references = self.tags.map do |tag|
      (match = tag.match(RESOURCE_REGEX)) ? match[2] : nil
    end

    @references.uniq.delete_if { |reference| reference.nil? }
  end

  def contains?(string)
    !!(@response =~ /#{string}/)
  end

  protected

  def get_page
    response = Net::HTTP.get_response(@uri)

    if response.is_a? Net::HTTPSuccess
      return response.body
    else
      @error = response
      raise BadPageError
    end
  end

  def tags
    @tags ||= @response.scan(TAG_REGEX).flatten
  end


end