require 'test_helper'

module Umedia
  module Thumbnail
    class KalturaVideoUrlTest < ActiveSupport::TestCase
      it 'generates an kaltura video thumb url' do
        field = Minitest::Mock.new
        field.expect :value, 'fake_type_here', []
        item = Minitest::Mock.new
        item.expect :field_viewer_type, field, []
        type_field = Minitest::Mock.new
        type_field.expect :value, 'fake_entry_id_123', []
        item.expect :field_fake_type_here, type_field, []

        url = KalturaVideoUrl.new(item: item)
        _(url.to_s).must_equal 'https://cdnapisec.kaltura.com/p/1369852/thumbnail/entry_id/fake_entry_id_123'
      end
    end
  end
end
