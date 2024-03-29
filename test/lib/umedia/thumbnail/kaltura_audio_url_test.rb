require 'test_helper'

module Umedia
  module Thumbnail
    class KalturaAudioUrlTest < ActiveSupport::TestCase
      it 'generates an kaltura audio thumb url' do
        url = KalturaAudioUrl.new
        _(url.to_s).must_equal 'https://d1rxd8nozvj6aj.cloudfront.net/umedia-audio-icon.png'
      end
    end
  end
end
