# frozen_string_literal: true

require 'test_helper'

class HomeTest < ActiveSupport::TestCase
  def teardown
    super
    Capybara.use_default_driver
  end

  describe 'when a search with no query has been submitted (the default search)' do
    it 'returns results' do
      Capybara.current_driver = :selenium
      visit '/search'
      sleep 1
      page.must_have_content('New Silver carols : a collection of new music for public schools')
    end

    it 'sorts z to a' do
      Capybara.current_driver = :selenium
      visit '/search'
      sleep 1
      find(:css, '#sort-dropdown > button').click
      sleep 1
      find(:css, '#sort-dropdown > ul > li:nth-child(3) > a').click
      sleep 1
      find(:xpath, '//*[@id="main"]/div[7]/div[1]/div/a[1]').text.must_equal('Vote Gay Pride')
    end
    it 'sorts creator a to z' do
      Capybara.current_driver = :selenium
      visit '/search'
      sleep 1
      find(:css, '#sort-dropdown > button').click
      sleep 1
      find(:css, '#sort-dropdown > ul > li:nth-child(4) > a').click
      sleep 1
      find(:xpath, '//*[@id="main"]/div[7]/div[1]/div/a[1]').text.must_equal('New Silver carols : a collection of new music for public schools')
    end
    it 'sorts creator z to a' do
      Capybara.current_driver = :selenium
      visit '/search'
      sleep 1
      find(:css, '#sort-dropdown > button').click
      sleep 1
      find(:css, '#sort-dropdown > ul > li:nth-child(5) > a').click
      sleep 1
      find(:xpath, '//*[@id="main"]/div[7]/div[1]/div/a[1]').text.must_equal('Bisbila, Student Yearbook, 1948')
    end
    it 'sorts by date, oldest first' do
      Capybara.current_driver = :selenium
      visit '/search'
      sleep 1
      find(:css, '#sort-dropdown > button').click
      sleep 1
      find(:css, '#sort-dropdown > ul > li:nth-child(6) > a').click
      sleep 1
      find(:xpath, '//*[@id="main"]/div[7]/div[1]/div/a[1]').text.must_equal('Plate 002 (Plate II), Yellow-billed Cuckoo')
    end
    it 'sorts by date, newest first' do
      Capybara.current_driver = :selenium
      visit '/search'
      sleep 1
      find(:css, '#sort-dropdown > button').click
      sleep 1
      find(:css, '#sort-dropdown > ul > li:nth-child(7) > a').click
      sleep 1
      find(:xpath, '//*[@id="main"]/div[7]/div[1]/div/a[1]').text.must_equal('Presenting the 2006 Twin Cities GLBT Pride Festival Entertainment…')
    end
    it 'sets 10 per page' do
      Capybara.current_driver = :selenium
      visit '/search'
      sleep 1
      find(:css, '#per-page-dropdown > button').click
      sleep 1
      find(:css, '#per-page-dropdown > ul > li:nth-child(1) > a').click
      sleep 1
      page.must_have_css('dl.item-metadata', count: 10)
    end
    it 'sets 20 per page' do
      Capybara.current_driver = :selenium
      visit '/search'
      sleep 1
      find(:css, '#per-page-dropdown > button').click
      sleep 1
      find(:css, '#per-page-dropdown > ul > li:nth-child(2) > a').click
      sleep 1
      page.must_have_css('dl.item-metadata', count: 20)
    end
    it 'sets 50 per page' do
      Capybara.current_driver = :selenium
      visit '/search'
      sleep 1
      find(:css, '#per-page-dropdown > button').click
      sleep 1
      find(:css, '#per-page-dropdown > ul > li:nth-child(3) > a').click
      sleep 1
      page.must_have_css('dl.item-metadata', count: 50)
    end
    it 'sets 100 per page' do
      Capybara.current_driver = :selenium
      visit '/search'
      sleep 1
      find(:css, '#per-page-dropdown > button').click
      sleep 1
      find(:css, '#per-page-dropdown > ul > li:nth-child(4) > a').click
      sleep 1
      page.must_have_css('dl.item-metadata', count: 100)
    end
    it 'facets' do
      Capybara.current_driver = :selenium
      visit '/search'
      sleep 1
      find(:xpath, '//*[@id="main"]/div[6]/div[1]/div[2]/ul/li[1]/a').click
      sleep 1
      find(:xpath, '//*[@id="main"]/div[7]/div[1]/div/a[1]').text.must_equal '2001: A Pride Odyssey'
    end
  end

  describe 'when searching records with titles orderd by number' do
    it 'sorts them correctly' do
      Capybara.current_driver = :selenium
      visit '/search'
      sleep 1
      fill_in 'q', with: 'plate'
      find(:xpath, '//*[@id="udc-search-control"]/form/div/span/button').click
      find(:xpath, '//*[@id="main"]/div[7]/div[1]/div/a[1]').text.must_equal('Plate 001 (Plate I), Wild Turkey')
      find(:xpath, '//*[@id="main"]/div[7]/div[2]/div/a[1]').text.must_equal('Plate 003 (Plate III), Prothonotary Warbler')
      find(:xpath, '//*[@id="main"]/div[7]/div[3]/div/a[1]').text.must_equal('Plate 004 (Plate IV), Purple Finch')
      page.body.must_match(/Plate 001.*/)
    end
  end
end
