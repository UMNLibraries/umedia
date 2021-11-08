require 'test_helper'

class HomeTest < ActiveSupport::TestCase
  def teardown
    super
    Capybara.use_default_driver
  end
  it 'loads the OSD viewer and a clickable list of sidebar child pages' do
    Capybara.current_driver = :selenium
    visit 'item/p16022coll345:69542'
    find(:css, ".ui-slider-handle").drag_by(0, 50)
    _(has_selector?(:xpath, '//*[@id="sidebar-p16022coll345:69215"]/div')).must_equal true
  end

  it 'sidebar pages are searchable' do
    Capybara.current_driver = :selenium
    visit 'item/p16022coll345:69542'
    fill_in 'q', with: 'Genetics'
    find(:xpath, '//*[@id="sidebar"]/form/div/span/button').click
    _(find(:xpath, '//*[@id="sidebar-p16022coll345:69197"]/div[2]/div[2]').text).must_equal "Committee on Genetics and Society Forum on the Green Revolution XIII International Congress"
    # Page 2 doesn't show up for this search result
    _(has_selector?(:xpath, '//*[@id="sidebar-p16022coll345:69195"]/div')).must_equal false

    # Ensure paging works on searches as well
    find(:css, ".ui-slider-handle").drag_by(0, 100)
    # We have paged to page 6, make sure it's there
    _(has_selector?(:xpath, '//*[@id="sidebar-p16022coll345:69199"]')).must_equal true
    # Clear the search
    find(:xpath, '//*[@id="sidebar-pages"]/div/a').click
    # Page 2 should be back in the list now
    _(has_selector?(:xpath, '//*[@id="sidebar-p16022coll345:69195"]/div')).must_equal true
  end
end
