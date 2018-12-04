require 'test_helper'

module Umedia
  module Thumbnail
    class ImageUrlTest < ActiveSupport::TestCase
      it 'generates an image url' do
        iiif_config_klass = Minitest::Mock.new
        iiif_config_klass_obj = Minitest::Mock.new
        iiif_config_klass.expect :new, iiif_config_klass_obj, [{ collection: 'col123', id: '999'}]
        iiif_config_klass_obj.expect :info, { 'sizes' => [{'width' => 350 }] }, []
        iiif_config_klass_obj.expect :endpoint, 'http://blerg', []
        url = ImageUrl.new(collection: 'col123', id: '999', iiif_config_klass: iiif_config_klass)
        url.to_s.must_equal 'http://blerg/digital/iiif/col123/999/full/350,/0/default.jpg'
        iiif_config_klass.verify
        iiif_config_klass_obj.verify
      end
    end
  end
end