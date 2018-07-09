require 'test_helper'

module Umedia
  class ThumbnailTest < ActiveSupport::TestCase
    describe 'when a the viewer is kaltura video' do
    it 'produces a kaltura thumbnail' do
      thumbnail = Thumbnail.new(object_url: 'fooo',
                                viewer_type: 'kaltura_video',
                                entry_id: '1234123')
    end
    end
  end
end
