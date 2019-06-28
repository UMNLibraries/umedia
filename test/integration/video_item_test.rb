require 'test_helper'

class AudioTest < ActiveSupport::TestCase
  def teardown
    super
    Capybara.use_default_driver
  end
  it 'loads a kaltura audio player' do
    Capybara.current_driver = :selenium
    visit '/item/p16022coll262:137'
    has_selector?(:xpath, '//*[@id="kaltura_player_ifp"]').must_equal true
  end
end
