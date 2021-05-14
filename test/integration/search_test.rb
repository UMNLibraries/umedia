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
      _(page).must_have_content('10,000 Lakes or More')
    end
    it 'sorts z to a' do
      Capybara.current_driver = :selenium
      visit '/search'
      sleep 1
      find(:css, '#sort-dropdown > button').click
      sleep 1
      find(:css, '#sort-dropdown > ul > li:nth-child(3) > a').click
      sleep 1
      _(find(:xpath, '//*[@id="main"]/div[7]/div[1]/div/div/a').text).must_equal('Warehouse work')
    end
    it 'sorts creator a to z' do
      Capybara.current_driver = :selenium
      visit '/search'
      sleep 1
      find(:css, '#sort-dropdown > button').click
      sleep 1
      find(:css, '#sort-dropdown > ul > li:nth-child(4) > a').click
      sleep 1
      _(find(:xpath, '//*[@id="main"]/div[7]/div[1]/div/div/a').text).must_equal('125th Anniversary Celebration, 1978. (Box 1, Folder 20)')
    end
    it 'sorts creator z to a' do
      Capybara.current_driver = :selenium
      visit '/search'
      sleep 1
      find(:css, '#sort-dropdown > button').click
      sleep 1
      find(:css, '#sort-dropdown > ul > li:nth-child(5) > a').click
      sleep 1
      _(find(:xpath, '//*[@id="main"]/div[7]/div[1]/div/div/a').text).must_equal('10,000 Lakes or More - Boating Opportunities')
    end
    it 'sorts by date, oldest first' do
      Capybara.current_driver = :selenium
      visit '/search'
      sleep 1
      find(:css, '#sort-dropdown > button').click
      sleep 1
      find(:css, '#sort-dropdown > ul > li:nth-child(6) > a').click
      sleep 1
      _(find(:xpath, '//*[@id="main"]/div[7]/div[1]/div/div/a').text).must_equal('15th Century, Afghanistan and Pakistan')
    end
    it 'sorts by date, newest first' do
      Capybara.current_driver = :selenium
      visit '/search'
      sleep 1
      find(:css, '#sort-dropdown > button').click
      find(:css, '#sort-dropdown > ul > li:nth-child(7) > a').click
      sleep 1
      _(find(:xpath, '//*[@id="main"]/div[7]/div[1]/div/div/a').text).must_equal('100 Years of Student Drawings: John Cunningham, Jane Hession, and Katherine Solomonson, Dec. 2014')
    end
    it 'sets 10 per page' do
      Capybara.current_driver = :selenium
      visit '/search'
      find(:css, '#per-page-dropdown > button').click
      find(:css, '#per-page-dropdown > ul > li:nth-child(1) > a').click
      page.must_have_css('dl.item-metadata', count: 10)
    end
  end

  describe 'when searching records with titles orderd by number' do
    it 'sorts them correctly' do
      Capybara.current_driver = :selenium
      visit '/search'
      fill_in 'q', with: 'plate museum'
      find(:xpath, '//*[@id="udc-search-control"]/form/div/span/button').click
      find(:css, '#sort-dropdown > button').click
      find(:css, '#sort-dropdown > ul.dropdown-menu > li:nth-child(2) > a').click
      _(find(:xpath, '//*[@id="main"]/div[7]/div[1]/div/div/a').text).must_equal('Plate 001 (Plate I), Wild Turkey')
      _(find(:xpath, '//*[@id="main"]/div[7]/div[2]/div/div/a').text).must_equal('Plate 002 (Plate II), Yellow-billed Cuckoo')
      _(find(:xpath, '//*[@id="main"]/div[7]/div[3]/div/div/a').text).must_equal('Plate 003 (Plate III), Prothonotary Warbler')
      _(page.body).must_match(/Plate 001.*/)
    end
  end
end
