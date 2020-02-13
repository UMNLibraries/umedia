# frozen_string_literal: true

require 'test_helper'

class SmallCompoundTest < ActiveSupport::TestCase
  def teardown
    super
    Capybara.use_default_driver
  end
  it 'loads the OSD viewer and a clickable list of sidebar child pages' do
    Capybara.current_driver = :selenium
    visit '/item/p16022coll416:904'
    find(:xpath, '//*[@id="osd-config"]')['data-config'].must_equal '{"currentRotation":0,"defaultZoomLevel":0,"tileSources":["https://cdm16022.contentdm.oclc.org/digital/iiif/p16022coll416/814/info.json"],"sequenceMode":false,"showReferenceStrip":false,"showNavigator":true,"id":"osd-viewer","visibilityRatio":1.0,"constrainDuringPan":false,"minZoomLevel":0,"maxZoomLevel":10,"zoomInButton":"zoom-in","zoomOutButton":"zoom-out","rotateRightButton":"rotate-right","rotateLeftButton":"rotate-left","homeButton":"reset","fullPageButton":"full-page","previousButton":"sidebar-previous","nextButton":"sidebar-next"}'
    find(:xpath, '//*[@id="sidebar-p16022coll416:815"]').click
    find(:xpath, '//*[@id="osd-config"]')['data-config'].must_equal '{"currentRotation":0,"defaultZoomLevel":0,"tileSources":["https://cdm16022.contentdm.oclc.org/digital/iiif/p16022coll416/815/info.json"],"sequenceMode":false,"showReferenceStrip":false,"showNavigator":true,"id":"osd-viewer","visibilityRatio":1.0,"constrainDuringPan":false,"minZoomLevel":0,"maxZoomLevel":10,"zoomInButton":"zoom-in","zoomOutButton":"zoom-out","rotateRightButton":"rotate-right","rotateLeftButton":"rotate-left","homeButton":"reset","fullPageButton":"full-page","previousButton":"sidebar-previous","nextButton":"sidebar-next"}'
  end
  it 'loads the OSD viewer and a clickable list of sidebar child pages' do
    Capybara.current_driver = :selenium
    visit '/item/p16022coll416:904'
    find(:xpath, '//*[@id="metadata-transcriptions"]').click
    find(:xpath, '//*[@id="metadata-area"]/div[85]/div').text.must_equal '1853 1978 1905 125TH ANNIVERSARY YMCAS SERI COMMUNITY 1978 Seventy-three years of service YMCA of MONTCLAIR'
  end
  it 'sidebar pages are searchable' do
    Capybara.current_driver = :selenium
    visit '/item/p16022coll416:904'
    fill_in 'q', with: 'national'
    sleep 4
    find(:xpath, '//*[@id="sidebar"]/form/div/span/button').click
    find(:xpath, '//*[@id="sidebar-p16022coll416:815"]/h4').text.must_equal 'Page 2'
    # Page 7 doesn't show up for this search result
    has_selector?(:xpath, '//*[@id="sidebar-p16022coll416:820"]/div/img').must_equal false
    # Clear the search
    find(:xpath, '//*[@id="sidebar-pages"]/div/a').click
    # Page 7 should be back in the list now
    has_selector?(:xpath, '//*[@id="sidebar-p16022coll416:820"]/div/img').must_equal true
  end
end
