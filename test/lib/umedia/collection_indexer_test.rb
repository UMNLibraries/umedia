require 'test_helper'

module Umedia
  class CollectionIndexerTest < ActiveSupport::TestCase
    it 'takes an array of collections and indexes them' do

      # FeaturedCollection mocks
      collection = Collection.new(set_spec: 'foo:blah', name: 'stuff', description: 'blergh')
      collections = [collection]
      featured_collection_klass = Minitest::Mock.new
      featured_collection_klass_obj = Minitest::Mock.new
      featured_collection_klass.expect :new, featured_collection_klass_obj, [collection: collection]
      featured_collection_klass_obj.expect :to_solr, {fake: 'solrconfig'}, []

      # SolrClient mocks
      solr_client = Minitest::Mock.new
      solr_client.expect :add, nil, [{fake: 'solrconfig'}]
      solr_client.expect :commit, nil, []

      CollectionIndexer.new(collections: collections,
                            solr: solr_client,
                            featured_collection_klass: featured_collection_klass).load!
      solr_client.verify
      featured_collection_klass.verify
      featured_collection_klass_obj.verify
    end
  end
end
