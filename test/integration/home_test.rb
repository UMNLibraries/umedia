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
      find(:xpath, '//*[@id="collections-home"]/div/div[3]/div[2]/nav/ul/li[4]/a').click
      click_link 'University of Minnesota Archives Audio Collection'
      page.must_have_content('10,000 Lakes or More')
    end
    it 'nex/prev and collections are clickable' do
      Capybara.current_driver = :selenium
      visit '/home'
      find(:xpath, '//*[@id="collections-home"]/div/div[3]/div[2]/nav/ul/li[4]/a').click
      find(:xpath, '//*[@id="collections-home"]/div/div[3]/div[2]/nav/ul/li[3]/a').click
      click_link 'Jesse Alexander Papers'
      page.must_have_content('125th Anniversary Celebration, 1978. (Box 1, Folder 20)')
    end
  end

  describe 'when no search params are entered and a user clicks go' do
    it 'displays an all items search' do
      visit '/home'
      find(:xpath, '//*[@id="home-controller-data"]/div[2]/form/div/span/button').click
      page.must_have_content('100 Years Sherlock Holmes')
    end
  end

  describe 'when a search param is entered and a user clicks go' do
    it 'displays relevant items' do
      visit '/home'
      fill_in 'q', with: 'pakistan'
      find(:xpath, '//*[@id="home-controller-data"]/div[2]/form/div/span/button').click
      page.must_have_content("15th Century, Afghanistan and Pakistan")
    end
  end
end
