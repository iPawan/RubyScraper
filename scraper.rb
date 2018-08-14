require 'byebug'
require 'httparty'
require 'nokogiri'

def scraper
  url = 'https://blockwork.cc'
  
  jobs =Array.new
  unparsed_page = HTTParty.get(url)
  parsed_page = Nokogiri::HTML(unparsed_page)
  job_listings = parsed_page.css('div.listingCard')
  jobs_per_page = job_listings.count
  total_jobs = parsed_page.css('div.job-count').text.gsub(/[^\d]/,'').to_i
  total_pages = (total_jobs.to_f / jobs_per_page.to_f).ceil
  puts total_pages
  byebug
  page = 1
  while page <= total_pages 
    job_listings = get_job_listings page
    job_listings.each do |job_listing|
      jobs << get_job_details(job_listing,url)
    end
    page += 1
  end
byebug
end

def get_job_listings(page)
    pagignation_url = "https://blockwork.cc/listings?page=#{page}"
    puts pagignation_url
    unparsed_page = HTTParty.get(pagignation_url)
    parsed_page = Nokogiri::HTML(unparsed_page)
    parsed_page.css('div.listingCard') 
end

def get_job_details(job_listing, url)
      {
        title: job_listing.css('span.job-title').text,
        location: job_listing.css('span.location').text,
        company: job_listing.css('span.company').text,
        url: url+job_listing.css('a')[0].attributes["href"].value
      }
end
scraper
