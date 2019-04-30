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
      sleep 1
      find(:xpath, '//*[@id="collections-home"]/div/div[3]/div[2]/nav/ul/li[4]/a').click
      click_link 'Frank Kiehne Papers'
      sleep 1
      page.must_have_content('Papers on Southtown YMCA Youth Work (Chicago, IL), 1947-1949. (Box 8, Folder 7)')
    end
    it 'nex/prev and collections are clickable' do
      Capybara.current_driver = :selenium
      visit '/home'
      sleep 1
      find(:xpath, '//*[@id="collections-home"]/div/div[3]/div[2]/nav/ul/li[4]/a').click
      find(:xpath, '//*[@id="collections-home"]/div/div[3]/div[2]/nav/ul/li[3]/a').click
      click_link 'Upper Midwest Jewish Archives Scrapbook Collection'
      sleep 1
      page.must_have_content('Alpha Epsilon Phi scrapbook')
    end
  end

  describe 'when no search params are entered and a user clicks go' do
    it 'displays an all items search' do
      visit '/home'
      find(:xpath, '//*[@id="home-controller-data"]/div[2]/form/div/span/button').click
      page.must_have_content('$1,000,000 national campaign for work among our soldiers and sailors : Dec. 2-9, 1917 : War Work Committee : the Sal')
    end
  end

  describe 'when a search param is entered and a user clicks go' do
    it 'displays relevant items' do
      visit '/home'
      fill_in 'q', with: 'love'
      find(:xpath, '//*[@id="home-controller-data"]/div[2]/form/div/span/button').click
      page.must_have_content("Strength to Love")
    end
  end
end
