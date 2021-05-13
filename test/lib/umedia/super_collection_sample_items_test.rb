require 'test_helper'

module Umedia
  class SuperCollectionSampleItemsTest < ActiveSupport::TestCase
    it 'retrieves a set of sample items and a total primary page count for a collection' do
      response = {'response' => {'docs' => ['foo'] } }
      solr = Minitest::Mock.new
      solr.expect :get, response, ["select", {:params=>{:rows=>3, :fl=>"*", :q=>"id:\"p16022coll349:8804\" || id:\"p16022coll243:1386\" || id:\"p16022coll174:3318\""}}]
      search = SuperCollectionSampleItems.new(collection_name: 'Exploring Minnesota\'s Natural History', solr: solr)
      _(search.iiifables.first.doc_hash).must_equal "foo"
      solr.verify
    end
  end
end
