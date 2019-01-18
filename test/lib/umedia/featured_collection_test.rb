require 'test_helper'

module Umedia
  class CollectionIndexerTest < ActiveSupport::TestCase

    let(:collection) { Collection.new(set_spec: 'foo:bar23', name: "foo col", description: "it's all cats") }
    let(:doc_hash) { {'id' => 'foobrah:9er', 'object' => 'ugh', 'first_viewer_type' => 'image', 'kaltura_video' => '123123s'} }
    let(:search_klass) { Minitest::Mock.new }
    let(:search_klass_obj) { Minitest::Mock.new }
    let(:item_klass) { Minitest::Mock.new }
    let(:item_klass_obj) { Minitest::Mock.new }
    let(:thumbnail_url_klass) { Minitest::Mock.new }
    let(:thumbnail_url_klass_obj) { Minitest::Mock.new }

   def setup
      # Sample Item Search mocks
      search_klass.expect :new, search_klass_obj, [{set_spec: collection.set_spec}]
      search_klass_obj.expect :num_found, 103, []
      items = [doc_hash]
      search_klass_obj.expect :items, items, []

      search_klass_obj.expect :first_primary_item, {'contributing_organization_name' => 'Fake Org Name Here'}, []

      # Item Mocks
      item_klass.expect :new, item_klass_obj, [{ doc_hash: doc_hash }]

      # Thumbnail Mocks
      thumbnail_url_klass.expect :new, thumbnail_url_klass_obj, [{ item: item_klass_obj, iiif_thumb: true }]
      thumbnail_url_klass_obj.expect :to_h, {thumbnails: ['blah']}, []
    end

    describe 'when a collection is not a super collection' do
      it 'produces a featured collection solr config and indicates it is not a super collection' do
        featured = FeaturedCollection.new(
          collection: collection,
          search_klass: search_klass,
          item_klass: item_klass,
          thumbnail_url_klass: thumbnail_url_klass
        )

        featured.to_h.must_equal(
          {:id=>"collection-foo:bar23", :document_type=>"collection", :set_spec=>"foo:bar23", :collection_name=>"foo col", :collection_description=>"it's all cats", :collection_item_count=>103, :contributing_organization_name=>"Fake Org Name Here", :collection_thumbnails=>"[{\"thumbnails\":[\"blah\"],\"id\":\"foobrah:9er\"}]", :is_super_collection=>false}
        )
        search_klass.verify
        search_klass_obj.verify
        item_klass.verify
        thumbnail_url_klass.verify
        thumbnail_url_klass_obj.verify
      end
    end

    describe 'when a collection is a super collection' do
      it 'produces a featured collection solr config and indicates it is a super collection' do
        featured = FeaturedCollection.new(
          collection: collection,
          search_klass: search_klass,
          item_klass: item_klass,
          thumbnail_url_klass: thumbnail_url_klass,
          super_collections: ['foo col']
        )

        featured.to_h.must_equal(
          {:id=>"collection-foo:bar23", :document_type=>"collection", :set_spec=>"foo:bar23", :collection_name=>"foo col", :collection_description=>"it's all cats", :collection_item_count=>103, :contributing_organization_name=>"Fake Org Name Here", :collection_thumbnails=>"[{\"thumbnails\":[\"blah\"],\"id\":\"foobrah:9er\"}]", :is_super_collection=>true}
        )
        search_klass.verify
        search_klass_obj.verify
        item_klass.verify
        thumbnail_url_klass.verify
        thumbnail_url_klass_obj.verify
      end
    end

    describe 'when a collection has no items' do
      it 'produces an empty hash' do
        search_klass = Minitest::Mock.new
        search_klass_obj = Minitest::Mock.new
        search_klass.expect :new, search_klass_obj, [{set_spec: collection.set_spec}]
        search_klass_obj.expect :num_found, 0, []
        items = [doc_hash]
        search_klass_obj.expect :items, items, []
        featured = FeaturedCollection.new(
          collection: collection,
          search_klass: search_klass,
          item_klass: item_klass,
          thumbnail_url_klass: thumbnail_url_klass,
          super_collections: ['foo col']
        )
        featured.to_h.must_equal({})
      end
    end
  end
end
