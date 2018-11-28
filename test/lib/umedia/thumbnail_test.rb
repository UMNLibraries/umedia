require 'test_helper'

module Umedia
  class ThumbnailTest < ActiveSupport::TestCase
    describe 'when a the viewer is kaltura video' do
      it 'produces a kaltura thumb url config' do
        thumbnail = Thumbnail.new(viewer_type: 'kaltura_video',
                                  entry_id: '1234123')
        thumbnail.to_h.must_equal({
          :default_url=>"https://d2y23onbq5rnfc.cloudfront.net/default_thumbnail.gif",
          :cdn_url=>"https://d2y23onbq5rnfc.cloudfront.net/366e0240daa2bf2a44fe1c7a8abde86619d43f7b.png",
          :url=>"https://cdnapisec.kaltura.com/p/1369852/thumbnail/entry_id/1234123"
        })
      end
    end

    describe 'when a the viewer is not kaltura video' do
      it 'produces thumbnail' do
        thumbnail = Thumbnail.new(object_url: 'fooo',
                                  viewer_type: 'anythingelse')
        thumbnail.to_h.must_equal({
          :default_url=>"https://d2y23onbq5rnfc.cloudfront.net/default_thumbnail.gif",
          :cdn_url=>"https://d2y23onbq5rnfc.cloudfront.net/520d41b29f891bbaccf31d9fcfa72e82ea20fcf0.png",
          :url=>"fooo"
        })
      end
    end
  end
end
