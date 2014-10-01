require "test/unit"

require_relative "../scraper.rb"

class TestScraper < Test::Unit::TestCase
  def test_get_ald_race_name()
    scraper = Scraper.new
    assert_equal(scraper.get_ald_race_name(1), "Alderman 1st Ward")
    assert_equal(scraper.get_ald_race_name(2), "Alderman 2nd Ward")
    assert_equal(scraper.get_ald_race_name(3), "Alderman 3rd Ward")
    assert_equal(scraper.get_ald_race_name(11), "Alderman 11th Ward")
    assert_equal(scraper.get_ald_race_name(12), "Alderman 12th Ward")
    assert_equal(scraper.get_ald_race_name(13), "Alderman 13th Ward")
  end

  def test_get_ald_races()
  	scraper = Scraper.new
	races = scraper.get_ald_races
	assert(races.include? "Alderman 1st Ward")
	assert(races.include? "Alderman 2nd Ward")
	assert(races.include? "Alderman 3rd Ward")
	assert(races.include? "Alderman 11th Ward")
	assert(races.include? "Alderman 12th Ward")
	assert(races.include? "Alderman 13th Ward")
	assert(races.include? "Alderman 50th Ward")
  end

  def test_parse_ald_results_html()
  	scraper = Scraper.new
  	test_html_file_path = File.expand_path("../../test_data/2011__alderman_1st_ward.html", __FILE__)
    html = File.read(test_html_file_path)
    results = scraper.parse_ald_results_html(html)
    result = results[0]
    assert_equal(result[:candidate], "PROCO ''JOE'' MORENO")
    assert_equal(result[:ward], "1")
    assert_equal(result[:votes], 7243)
  end
end
