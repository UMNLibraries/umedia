require 'test_helper'

module Umedia
  class FeaturedCollectionTest < ActiveSupport::TestCase
    describe 'when a standard collection is not empty' do
      it 'produces a featured collection solr config' do
        set_spec = "gergle:123"
        sample_klass = mock()
        sample_klass_obj = mock()
        sample_klass.expects(:new).with({set_spec: set_spec}).returns(sample_klass_obj)
        sample_klass_obj.expects(:contributing_organization_name).returns('Gopher Society')
        iiifable_item = mock()
        iiifable_item.expects(:index_id).returns('123:44')
        sample_klass_obj.expects(:iiifables).returns([iiifable_item])

        collection = mock()
        collection.expects(:item_count).returns(99).times(2)
        collection.expects(:set_spec).returns(set_spec).times(4)

        collection.expects(:description).returns("herper derp")
        collection.expects(:display_name).returns('pretty name here')
        collection.expects(:super_collection?).returns(false).times(2)

        # Thumbnail Mocks
        thumbnail_url_klass = mock()
        thumbnail_url_klass_obj = mock()
        thumbnail_url_klass.expects(:new).with({item: iiifable_item, iiif_thumb: true}).returns(thumbnail_url_klass_obj)
        thumbnail_url_klass_obj.expects(:to_h).returns({thumbnails: ['blah']})

        featured = FeaturedCollection.new(
          collection: collection,
          sample_klass: sample_klass,
          thumbnail_url_klass: thumbnail_url_klass
        )

        _(featured.to_h).must_equal({:id=>"collection-gergle:123", :document_type=>"collection", :set_spec=>"gergle:123", :collection_name=>"pretty name here", :collection_description=>"herper derp", :collection_item_count=>99, :contributing_organization_name=>"Gopher Society", :collection_thumbnails=>"[{\"thumbnails\":[\"blah\"],\"id\":\"123:44\"}]", :is_super_collection=>false, :collection_recency_sort=>123})
      end
    end

    describe 'when a standard collection is empty' do
      it 'produces a featured collection solr config' do
        collection = mock()
        collection.expects(:item_count).returns(0)
        collection.expects(:set_spec).returns("gergle:123")
        collection.expects(:super_collection?).returns(false)
        featured = FeaturedCollection.new(
          collection: collection
        )
        _(featured.to_h).must_equal({})
      end
    end

    describe 'when a collection is a super collection' do
      it 'produces a featured super collection solr config' do
        set_spec = "gergle:123"
        super_sample_klass = mock()
        super_sample_klass_obj = mock()
        super_sample_klass.expects(:new).with({:collection_name=>"display name here"}).returns(super_sample_klass_obj)
        super_sample_klass_obj.expects(:contributing_organization_name).returns('Gopher Society')
        iiifable_item = mock()
        iiifable_item.expects(:index_id).returns('123:44')
        super_sample_klass_obj.expects(:iiifables).returns([iiifable_item])

        super_collection = mock()
        super_collection.expects(:item_count).returns(99).times(2)
        super_collection.expects(:set_spec).returns(set_spec).times(3)

        super_collection.expects(:description).returns("herper derp")
        super_collection.expects(:display_name).returns('display name here').times(2)
        super_collection.expects(:super_collection?).returns(true).times(2)

        # Thumbnail Mocks
        thumbnail_url_klass = mock()
        thumbnail_url_klass_obj = mock()
        thumbnail_url_klass.expects(:new).with({item: iiifable_item, iiif_thumb: true}).returns(thumbnail_url_klass_obj)
        thumbnail_url_klass_obj.expects(:to_h).returns({thumbnails: ['blah']})

        featured = FeaturedCollection.new(
          collection: super_collection,
          super_sample_klass: super_sample_klass,
          thumbnail_url_klass: thumbnail_url_klass
        )

        _(featured.to_h).must_equal({:id=>"collection-gergle:123", :document_type=>"collection", :set_spec=>"gergle:123", :collection_name=>"display name here", :collection_description=>"herper derp", :collection_item_count=>99, :contributing_organization_name=>"Gopher Society", :collection_thumbnails=>"[{\"thumbnails\":[\"blah\"],\"id\":\"123:44\"}]", :is_super_collection=>true, :collection_recency_sort=>123})
      end
    end
  end
end
