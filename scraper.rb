 #!/usr/bin/env ruby

require 'mechanize'
require 'nokogiri'

class Scraper
  @@municipal_general_election_2011_url = "http://www.chicagoelections.com/en/wdlevel3.asp?elec_code=25"

  def get_ald_races
    r = Array.new
    for i in 1..50      
      r.push(self.get_ald_race_name(i))
    end
    return r
  end

  # Alex, I "refactored" (see http://en.wikipedia.org/wiki/Code_refactoring if 
  # you're not familiar with the term) the logic you wrote today into its own
  # method to make it easier to test.  I didn't change any of the logic, I just
  # made it it's own unit.  Look how simple the get_ald_races() method is now!
  def get_ald_race_name(ward_num)
  	l = ward_num.to_s
    last = l[-1,1]
    first = l[0]

    if l == "1"
      suffix = "st"
    elsif last == "1" and first != "1"
      suffix = "st"
    elsif last == "2" and first != "1"
      suffix = "nd"
    elsif last == "3" and first != "1"
      suffix = "rd"
    else
      suffix = "th"
    end

    return "Alderman #{ward_num}#{suffix} Ward"
  end

  # Return a string containing the result HTML for a particular race
  #
  # ==== Arguments
  #
  # * +race+ - String representing an aldermanic race.  For example "Alderman 1st Ward"
  #
  # ==== Returns
  #
  # A string containing the HTML from the results website for the race
  def get_ald_results_html(race)
    agent = Mechanize.new
    # Get the map of POST parameters needed to get the results page
    params = self.get_ald_post_params(race)
    # Use Mechanize to request the results page
    page = agent.post(params)
    # Return the body of the page.  This will be the HTML representing the
    # results page.  We'll have to parse this in another method.
    return page.body
  end

  # Get the post parameters needed to retrieve a race's results 
  #
  # ==== Arguments
  # 
  # * +race+ - String representing an aldermanic race.  For example "Alderman 1st Ward"
  #
  # ==== Returns
  # 
  # A hash with keys and values representing the POST parameters
  def get_ald_post_params(race)
    # TODO: Return a hash that contains the following keys/values
    # This is a good place to start
    # * VTI-GROUP:0
    # * D3:Alderman 1st Ward (the value of the race argument)
    # * flag:1
    # *B1:  View The Results   
    return {}
  end

  # Parse the results HTML
  #
  # ==== Arguments
  # 
  # * +html+ - String containing HTML of the results page
  #
  # ==== Returns
  #
  # An array of hashes where each hash looks something like this
  # {
  #   office: "Alderman 1st Ward",
  #   candidate: 'PROCO ''JOE'' MORENO',
  #   ward:'1',
  #   votes: 7243,
  #   percentage: 73.56,
  # }
  def parse_ald_results_html(html)
    doc = Nokogiri::HTML(html)
    results = Array.new
    # TODO: Use Nokogiri to parse the HTML
    # It's probably easies to use CSS selectors to get the values you want
    # See http://nokogiri.org/Nokogiri/XML/Node.html#method-i-css
    return results
  end
end

if __FILE__ == $0
  s = Scraper.new()
  #s.run
  puts s.get_ald_races
end