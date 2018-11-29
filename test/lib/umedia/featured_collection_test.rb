require 'test_helper'

module Umedia
  class CollectionIndexerTest < ActiveSupport::TestCase
    it 'produces a featured collection solr config' do
      collection = Collection.new(set_spec: 'foo:bar23', name: "foo col", description: "it's all cats")

      # Sample Item Search mocks
      search_klass = Minitest::Mock.new
      search_klass_obj = Minitest::Mock.new
      search_klass.expect :new, search_klass_obj, [{set_spec: collection.set_spec}]
      search_klass_obj.expect :num_found, 103, []
      items = [{'id' => 'foobrah:9er', 'object' => 'ugh', 'first_viewer_type' => 'image', 'kaltura_video' => '123123s'}]
      search_klass_obj.expect :items, items, []

      # Thumbnail Mocks
      thumbnail_klass = Minitest::Mock.new
      thumbnail_klass_obj = Minitest::Mock.new
      thumbnail_klass.expect :new, thumbnail_klass_obj, [{
        object_url: 'ugh',
        viewer_type: 'image',
        entry_id: '123123s'
      }]
      thumbnail_klass_obj.expect :to_h, {stuff: 'here'}, []


      featured = FeaturedCollection.new(
        collection: collection,
        search_klass: search_klass,
        thumbnail_klass: thumbnail_klass
      )

      featured.to_solr.must_equal(
        {:id=>"collection-foo:bar23", :document_type=>"collection", :set_spec=>"foo:bar23", :collection_name=>"foo col", :collection_description=>"it's all cats", :collection_item_count=>103, :collection_thumbnails=>"[{\"stuff\":\"here\",\"id\":\"foobrah:9er\"}]"}
      )
        search_klass.verify
      search_klass_obj.verify
      thumbnail_klass.verify
      thumbnail_klass_obj.verify
    end
  end
end
