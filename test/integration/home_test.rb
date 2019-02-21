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
      click_link 'Cuneiform Collection'
      sleep 1
      page.must_have_content('Cuneiform Inscriptions: UM 12')
    end
    it 'nex/prev and collections are clickable' do
      Capybara.current_driver = :selenium
      visit '/home'
      sleep 1
      find(:xpath, '//*[@id="collections-home"]/div/div[3]/div[2]/nav/ul/li[4]/a').click
      find(:xpath, '//*[@id="collections-home"]/div/div[3]/div[2]/nav/ul/li[3]/a').click
      click_link 'Bisbila University High School Yearbook'
      sleep 1
      page.must_have_content('Bisbila, Student Yearbook, 1963')
    end
  end

  describe 'when no search params are entered and a user clicks go' do
    it 'displays an all items search' do
      visit '/home'
      find(:xpath, '//*[@id="home-controller-data"]/div[2]/form/div/span/button').click
      page.must_have_content('Hymns for Sunday schools : selected from various authors')
    end
  end

  describe 'when a search param is entered and a user clicks go' do
    it 'displays relevant items' do
      visit '/home'
      fill_in 'q', with: 'love'
      find(:xpath, '//*[@id="home-controller-data"]/div[2]/form/div/span/button').click
      page.must_have_content("Deja's Love Boat")
    end
  end
end
