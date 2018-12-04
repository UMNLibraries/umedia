require 'test_helper'

module Umedia
  module Thumbnail
    class KalturaVideoUrlTest < ActiveSupport::TestCase
      it 'generates an kaltura video thumb url' do
        url = KalturaVideoUrl.new(entry_id: '123459')
        url.to_s.must_equal 'https://cdnapisec.kaltura.com/p/1369852/thumbnail/entry_id/123459'
      end
    end
  end
end
