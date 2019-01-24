require 'test_helper'

module Umedia
  class CollectionIndexerTest < ActiveSupport::TestCase
    it 'takes an array of collections and indexes them' do
      thumbs = ['cdn' => 'http://foocdn.com', 'url' => 'http://www.example.com'].to_json
      to_h = { collection_thumbnails: thumbs }
      # FeaturedCollection mocks
      collection = Collection.new(set_spec: 'foo:blah', name: 'stuff', description: 'blergh')
      featured_collection_klass = Minitest::Mock.new
      featured_collection_klass_obj = Minitest::Mock.new
      featured_collection_klass.expect :new, featured_collection_klass_obj, [collection: collection]
      featured_collection_klass_obj.expect :to_h, to_h, []

      # SolrClient mocks
      solr_client = Minitest::Mock.new
      solr_client.expect :add, nil, [to_h]
      solr_client.expect :commit, nil, []

      # Thumbnailer Mocks
      thumbnailer_klass = Minitest::Mock.new
      thumbnailer_klass_obj = Minitest::Mock.new
      thumbnailer_klass.expect :new, thumbnailer_klass_obj, [{:thumb_url=>"http://www.example.com", :cdn_url=>"http://foocdn.com"}]
      thumbnailer_klass_obj.expect :upload!, nil, []

      CollectionIndexer.new(collection: collection,
                            solr: solr_client,
                            featured_collection_klass: featured_collection_klass,
                            thumbnailer_klass: thumbnailer_klass).index!
      solr_client.verify
      featured_collection_klass.verify
      featured_collection_klass_obj.verify
    end
  end
end
