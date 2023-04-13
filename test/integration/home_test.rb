# frozen_string_literal: true

require 'test_helper'

class HomeTest < ActiveSupport::TestCase
  def teardown
    super
    Capybara.use_default_driver
  end

  describe 'when it displays a pagable set of collections' do
    it 'pages and collections are clickable' do
      Capybara.current_driver = :selenium
      visit '/home'
      # Click the second page of the pager (link 4 after prev,next,1)
      find(:xpath, '//*[@id="collections-home"]/div/div[3]/div[2]/nav/ul/li[4]/a').click
      #click_link 'The De Mey van Streefkerk Papers'
      click_link 'Atlantic World'
      #_(page).must_have_content('Letter, to a fellow heir')
      _(page).must_have_content('Letter, to a fellow heir')
    end
    it 'nex/prev and collections are clickable' do
      Capybara.current_driver = :selenium
      visit '/home'
      # Click the 2nd page of the pager (link 3 after prev,next)
      find(:xpath, '//*[@id="collections-home"]/div/div[3]/div[2]/nav/ul/li[3]/a').click
      # Click "next" 3x to advance 4 pages
      find(:xpath, '//*[@id="collections-home"]/div/div[3]/div[2]/nav/ul/li[2]/a').click
      find(:xpath, '//*[@id="collections-home"]/div/div[3]/div[2]/nav/ul/li[2]/a').click
      find(:xpath, '//*[@id="collections-home"]/div/div[3]/div[2]/nav/ul/li[2]/a').click
      find(:xpath, '//*[@id="collections-home"]/div/div[3]/div[2]/nav/ul/li[2]/a').click
      # Click "previous" once to land on a known record
      find(:xpath, '//*[@id="collections-home"]/div/div[3]/div[2]/nav/ul/li[1]/a').click
      # We should land here:
      click_link 'Minnesota\'s Radio History'
      _(page).must_have_content('10,000 Lakes or More')
    end
  end

  describe 'when no search params are entered and a user clicks go' do
    it 'displays an all items search' do
      visit '/home'
      find(:xpath, '//*[@id="home-controller-data"]/div[2]/form/div/span/button').click
      _(page).must_have_content('100 Years Sherlock Holmes')
    end
  end

  describe 'when a search param is entered and a user clicks go' do
    it 'displays relevant items' do
      visit '/home'
      fill_in 'q', with: 'pakistan'
      find(:xpath, '//*[@id="home-controller-data"]/div[2]/form/div/span/button').click
      _(page).must_have_content('15th Century, Afghanistan and Pakistan')
    end
  end
end
