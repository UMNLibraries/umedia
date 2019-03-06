require 'test_helper'

class SingleImageTest < ActiveSupport::TestCase
  def teardown
    super
    Capybara.use_default_driver
  end
  it 'loads the OSD viewer' do
    Capybara.current_driver = :selenium
    visit '/item/p16022coll251:4144'
    sleep 1
    has_selector?(:xpath, '//*[@id="osd-viewer"]/div/div[1]/canvas').must_equal true
  end
  it 'presents a clickable download link' do
    Capybara.current_driver = :selenium
    visit '/item/p16022coll251:4144'
    sleep 1
    find(:xpath, '//*[@id="image-download-dropdown"]/span[1]').click
    has_selector?(:xpath, '//*[@id="menu1"]/li[1]/a').must_equal true
  end
  it 'displays a clickable list of related items' do
    Capybara.current_driver = :selenium
    visit '/item/p16022coll251:4144'
    sleep 1
    find(:xpath, '//*[@id="main"]/div[4]/ul/li[1]/a/h3').click
    sleep 1
    find(:xpath, '//*[@id="main"]/h1').text.must_equal('16th Century, Acapulco and Puerto Marques')
  end
  it 'displays a metadata details list' do
    Capybara.current_driver = :selenium
    visit '/item/p16022coll251:4144'
    sleep 1
    find(:xpath, '//*[@id="metadata-area"]/div/dl[6]/dd[1]').text.must_equal 'Bell Call # 1590 fBr v. 4 pt. 11-2 (Plate XIII); Map ID 1590_fBr_v4_pt11-2_m012'
  end
  it 'displays collection description area' do
    Capybara.current_driver = :selenium
    visit '/item/p16022coll251:4144'
    sleep 1
    find(:xpath, '//*[@id="metadata-area"]/div/div').text.must_equal 'Historical Maps The James Ford Bell Library makes history come alive through its collection of maps, rare books, & manuscripts that focus on trade & cross-cultural interaction circa 1800. Our premier collection of more than 25,000 rare books, maps, and manuscripts illustrates the ways in which cultural influences expanded worldwide, with a special emphasis on European interactions. The Bell Library, its collection, and its innovative programs support scholarship and education at all levels, and enrich our community by advancing understanding of this global heritage, making the world we live in more meaningful. The items in the collection currently date between 400 C.E. and 1825 C.E.'
  end
  it 'provides a clickable json link' do
    Capybara.current_driver = :selenium
    visit '/item/p16022coll251:4144'
    sleep 1
    find(:xpath, '//*[@id="main"]/a/span[2]').click
    JSON.parse(page.text)['id'].must_equal 'p16022coll251:4144'
  end
  it 'displays a clickable citation style list' do
    Capybara.current_driver = :selenium
    visit '/item/p16022coll251:4144'
    sleep 1
    find(:xpath, '//*[@id="metadata-cites"]/a').click
    sleep 1
    find(:xpath, '//*[@id="metadata-area"]/div/span[1]').text.must_equal('16th Century, Acapulco. 1590. University of Minnesota Libraries, James Ford Bell Library., umedia.lib.umn.edu/item/p16022coll251:4144 Accessed 06 Mar 2019.')
    find(:xpath, '//*[@id="metadata-area"]/div/span[2]').text.must_equal('1590."16th Century, Acapulco." University of Minnesota Libraries, James Ford Bell Library., Accessed March 06, 2019. https://umedia.lib.umn.edu/item/p16022coll251:4144')
    find(:xpath, '//*[@id="metadata-area"]/div/span[3]').text.must_equal('<ref name="University of Minnesota"> {{cite web | url=http://umedia.lib.umn.edu/item/p16022coll251:4144 | | title= (Cartographic) 16th Century, Acapulco, | accessdate=06 Mar 2019 | publisher=University of Minnesota Libraries, James Ford Bell Library.}} </ref>')
  end
end
