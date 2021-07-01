require 'test_helper'

module Umedia
  module Thumbnail
    class ImageUrlTest < ActiveSupport::TestCase
      describe 'when an client does not request a IIIF thumbnal' do
        it 'generates an default image url' do
          item = mock()
          item.expects(:collection).returns('col123')
          item.expects(:id).returns('999')

          field = mock()
          field.expects(:value).returns('http://exaample.com/object')
          item.expects(:field_object).returns(field)

          url = ImageUrl.new(item: item)
          _(url.to_s).must_equal 'http://exaample.com/object'
        end
      end

      describe 'when an client requests a IIIF thumbnal' do
        it 'generates an IIIF image url' do
          iiif_config_klass = mock()
          iiif_config_klass_obj = mock()
	  iiif_config_klass.expects(:new).with({ collection: 'col123', id: '999'}).returns(iiif_config_klass_obj)
          iiif_config_klass_obj.expects(:info).returns({'sizes' => [{'width' => 350}]})
          iiif_config_klass_obj.expects(:endpoint).returns('http://blerg')

          item = mock()
          item.expects(:collection).returns('col123')
          item.expects(:id).returns('999')
          item.expects(:collection).returns('col123')
          item.expects(:id).returns('999')

          url = ImageUrl.new(item: item, iiif_config_klass: iiif_config_klass, iiif_thumb: true)
          _(url.to_s).must_equal 'http://blerg/digital/iiif/col123/999/full/350,/0/default.jpg'
        end
      end
    end
  end
end
