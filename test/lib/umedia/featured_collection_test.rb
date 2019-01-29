require 'test_helper'

module Umedia
  class FeaturedCollectionTest < ActiveSupport::TestCase
    describe 'when a standard collection is not empty' do
      it 'produces a featured collection solr config' do
        set_spec = "gergle:123"
        sample_klass = Minitest::Mock.new
        sample_klass_obj = Minitest::Mock.new
        sample_klass.expect :new, sample_klass_obj, [{set_spec: set_spec}]
        sample_klass_obj.expect :contributing_organization_name, 'Gopher Society', []
        sample_klass_obj.expect :iiifables, ['one'], []

        collection = Minitest::Mock.new
        collection.expect :item_count, 99, []
        collection.expect :item_count, 99, []
        collection.expect :set_spec, set_spec, []
        collection.expect :set_spec, set_spec, []
        collection.expect :set_spec, set_spec, []
        collection.expect :description, "herper derp", []
        collection.expect :display_name, 'pretty name here', []
        collection.expect :super_collection?, false, []
        collection.expect :super_collection?, false, []

        # Thumbnail Mocks
        thumbnail_url_klass = Minitest::Mock.new
        thumbnail_url_klass_obj = Minitest::Mock.new
        thumbnail_url_klass.expect :new, thumbnail_url_klass_obj, [ { item: 'one', iiif_thumb: true } ]
        thumbnail_url_klass_obj.expect :to_h, { thumbnails: ['blah'] }, []

        featured = FeaturedCollection.new(
          collection: collection,
          sample_klass: sample_klass,
          thumbnail_url_klass: thumbnail_url_klass
        )

        featured.to_h.must_equal({:id=>"collection-gergle:123", :document_type=>"collection", :set_spec=>"gergle:123", :collection_name=>"pretty name here", :collection_description=>"herper derp", :collection_item_count=>99, :contributing_organization_name=>"Gopher Society", :collection_thumbnails=>"[{\"thumbnails\":[\"blah\"],\"id\":null}]", :is_super_collection=>false})
        sample_klass.verify
        sample_klass_obj.verify
        collection.verify
        thumbnail_url_klass.verify
        thumbnail_url_klass_obj.verify
      end
    end

    describe 'when a standard collection is empty' do
      it 'produces a featured collection solr config' do
        collection = Minitest::Mock.new
        collection.expect :item_count, 0, []
        collection.expect :set_spec, "gergle:123", []
        collection.expect :super_collection?, false, []
        featured = FeaturedCollection.new(
          collection: collection
        )
        featured.to_h.must_equal({})
        collection.verify
      end
    end

    describe 'when a collection is a super collection' do
      it 'produces a featured super collection solr config' do
        set_spec = "gergle:123"
        super_sample_klass = Minitest::Mock.new
        super_sample_klass_obj = Minitest::Mock.new
        super_sample_klass.expect :new, super_sample_klass_obj, [{:collection_name=>"display name here"}]
        super_sample_klass_obj.expect :contributing_organization_name, 'Gopher Society', []
        super_sample_klass_obj.expect :iiifables, ['one'], []

        super_collection = Minitest::Mock.new
        super_collection.expect :item_count, 99, []
        super_collection.expect :item_count, 99, []
        super_collection.expect :set_spec, set_spec, []
        super_collection.expect :description, "herper derp", []
        super_collection.expect :display_name, 'display name here', []
        super_collection.expect :display_name, 'display name here', []
        super_collection.expect :super_collection?, true, []
        super_collection.expect :super_collection?, true, []

        # Thumbnail Mocks
        thumbnail_url_klass = Minitest::Mock.new
        thumbnail_url_klass_obj = Minitest::Mock.new
        thumbnail_url_klass.expect :new, thumbnail_url_klass_obj, [ { item: 'one', iiif_thumb: true } ]
        thumbnail_url_klass_obj.expect :to_h, { thumbnails: ['blah'] }, []

        featured = FeaturedCollection.new(
          collection: super_collection,
          super_sample_klass: super_sample_klass,
          thumbnail_url_klass: thumbnail_url_klass
        )

        featured.to_h.must_equal({:id=>"collection-gergle:123", :document_type=>"collection", :set_spec=>"gergle:123", :collection_name=>"display name here", :collection_description=>"herper derp", :collection_item_count=>99, :contributing_organization_name=>"Gopher Society", :collection_thumbnails=>"[{\"thumbnails\":[\"blah\"],\"id\":null}]", :is_super_collection=>true})
        super_sample_klass.verify
        super_sample_klass_obj.verify
        super_collection.verify
        thumbnail_url_klass.verify
        thumbnail_url_klass_obj.verify
      end
    end
  end
end
