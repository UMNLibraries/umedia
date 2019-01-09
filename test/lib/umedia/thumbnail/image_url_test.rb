require 'test_helper'

module Umedia
  module Thumbnail
    class ImageUrlTest < ActiveSupport::TestCase
      describe 'when an client does not request a IIIF thumbnal' do
        it 'generates an default image url' do
          item = Minitest::Mock.new
          item.expect :collection, 'col123', []
          item.expect :id, '999', []

          field = Minitest::Mock.new
          field.expect :value, 'http://exaample.com/object', []
          item.expect :field_object, field, []

          url = ImageUrl.new(item: item)
          url.to_s.must_equal 'http://exaample.com/object'
          item.verify
          field.verify
        end
      end

      describe 'when an client requests a IIIF thumbnal' do
        it 'generates an IIIF image url' do
          iiif_config_klass = Minitest::Mock.new
          iiif_config_klass_obj = Minitest::Mock.new
          iiif_config_klass.expect :new, iiif_config_klass_obj, [{ collection: 'col123', id: '999'}]
          iiif_config_klass_obj.expect :info, { 'sizes' => [{'width' => 350 }] }, []
          iiif_config_klass_obj.expect :endpoint, 'http://blerg', []

          item = Minitest::Mock.new
          item.expect :collection, 'col123', []
          item.expect :id, '999', []
          item.expect :collection, 'col123', []
          item.expect :id, '999', []

          url = ImageUrl.new(item: item, iiif_config_klass: iiif_config_klass, iiif_thumb: true)
          url.to_s.must_equal 'http://blerg/digital/iiif/col123/999/full/350,/0/default.jpg'
          iiif_config_klass.verify
          iiif_config_klass_obj.verify
          item.verify
        end
      end
    end
  end
end