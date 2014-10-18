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

  def get_ald_race_name(ward_num)
  	l = ward_num.to_s
    last = l[-1,1]
    first = l[0]

    if l == "1"
      suffix = "st"
    elsif last == "1" && first != "1"
      suffix = "st"
    elsif last == "2" && first != "1"
      suffix = "nd"
    elsif last == "3" && first != "1"
      suffix = "rd"
    else
      suffix = "th"
    end

    return "Alderman #{ward_num}#{suffix} Ward"
  end


  def get_ald_results_html(race_name)
    agent = Mechanize.new
    params = get_ald_post_params(race_name)
    page = agent.post(@@municipal_general_election_2011_url, params)
    return page.body
  end


  def get_ald_post_params(race_name)
    form = { "VTI-GROUP" => 0, :D3 => race_name, :flag => 1, :B1 => "View The Results"}
    return form
  end

  def get_office(doc)
	office = doc.css('body > table:nth-child(1) > tr:nth-child(1) > td > p > font > b').first.text
	office = office.sub! " -- ", ""
	return office
  end

  def get_ward(doc)
    ward = doc.css('body > table:nth-child(1) > tr:nth-child(4) > td:nth-child(1) > p > font > b > a').text
    return ward
  end

  def get_candidate(doc)
    has_candidates = true
    n = 3
    candidate_array = []
    while has_candidates  do
      candidate = doc.css("body > table:nth-child(1) > tr:nth-child(3) > td:nth-child(#{n}) > b > font > p").text
      candidate = candidate.strip
      if candidate != ""
          candidate_array.push(candidate)
      else
          has_candidates = false
      end
      n = n + 2
    end
    
    return candidate_array
  end

  def get_votes(doc)
    has_votes = true
    n = 3
    votes_array = []
    while has_votes  do
      votes = doc.css("body > table:nth-child(1) > tr:nth-child(4) > td:nth-child(#{n}) > p > font > b").text
      votes = votes.strip
      if votes != ""
        votes_array.push(votes)
      else
        has_votes = false
      end
      n = n + 2
    end
    return votes_array
  end

  def parse_ald_results_html(html)
    doc = Nokogiri::HTML(html)
    results = Array.new
    office = get_office(doc)
    ward = get_ward(doc)
    candidate = get_candidate(doc)
    votes = get_votes(doc)
    results = [:office => office, :ward => ward, :candidate => candidate, :votes => votes]
    return results
  end

  def get_results
    results = []
    get_ald_races.each do |race_name|
       html = get_ald_results_html(race_name)
       html_parsed = parse_ald_results_html(html)
       results += html_parsed
    end
    return results
  end
end

if __FILE__ == $0
  s = Scraper.new()
  #s.run
  puts s.get_results
end