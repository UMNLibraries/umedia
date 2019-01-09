require 'test_helper'

module Umedia
  class SuperCollectionSearchTest < ActiveSupport::TestCase
    it 'searches for a super collection' do
      solr = Minitest::Mock.new
      response = {
        'facet_counts' =>
        {
          'facet_fields' => {
            'super_collection_name_ss' => ['Foo Collection', 123, 'bar collection', 333]
          }
        }
      }
      solr.expect :get, response, ["select", {:params=>{:q=>"super_collection_names:[* TO *]", :rows=>0, "facet.field"=>"super_collection_name_ss", "facet.limit"=>100, "facet"=>true}}]
      SuperCollectionSearch.new(solr: solr).collections
      solr.verify
    end
  end
end
