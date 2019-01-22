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
      find(:xpath, '//*[@id="pager-top"]/div/nav/ul/li[4]/a').click
      click_link 'National Sustainable Agriculture Oral History Project'
      sleep 1
      page.must_have_content('Interview with Sister Mary Tacheny')
    end
    it 'nex/prev and collections are clickable' do
      Capybara.current_driver = :selenium
      visit '/home'
      sleep 1
      find(:xpath, '//*[@id="pager-top"]/div/nav/ul/li[2]/a/span').click
      find(:xpath, '//*[@id="pager-top"]/div/nav/ul/li[1]/a/span').click
      find(:xpath, '//*[@id="pager-top"]/div/nav/ul/li[2]/a/span').click
      click_link 'National Sustainable Agriculture Oral History Project'
      sleep 1
      page.must_have_content('Interview with Sister Mary Tacheny')
    end
  end

  describe 'when no search params are entered and a user clicks go' do
    it 'displays an all items search' do
      visit '/home'
      find(:xpath, '//*[@id="home-controller-data"]/div[2]/form/div/span/button').click
      page.must_have_content('Interview with Wes Jackson')
    end
  end

  describe 'when a search param is entered and a user clicks go' do
    it 'displays relevant items' do
      visit '/home'
      fill_in 'q', with: 'art'
      find(:xpath, '//*[@id="home-controller-data"]/div[2]/form/div/span/button').click
      page.must_have_content('Art of the Eye Videos')
    end
  end
end
