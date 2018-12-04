require 'test_helper'

module Umedia
  module Thumbnail
    class KalturaAudioUrlTest < ActiveSupport::TestCase
      it 'generates an kaltura audio thumb url' do
        url = KalturaAudioUrl.new
        url.to_s.must_equal 'http://d1rxd8nozvj6aj.cloudfront.net/umedia-audio-icon.png'
      end
    end
  end
end
