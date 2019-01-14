require 'test_helper'

module Umedia
  class CollectionSampleSearchTest < ActiveSupport::TestCase
    it 'retrieves a set of sample items and a total primary page count for a collection' do
      response = {
        'response' => {
          'docs' => ['123'],
          'numFound' => 1
        }
      }
      solr = Minitest::Mock.new
      solr.expect :get, response, ["select", {:params=>{:rows=>3, :fl=>"*", :sort=>"featured_collection_order asc", :q=>"(set_spec:foobarbaz123 || super_collection_set_specs:foobarbaz123) && document_type:item && record_type:primary"}}]
      solr.expect :get, response, ["select", {:params=>{:rows=>3, :fl=>"*", :sort=>"featured_collection_order asc", :q=>"(set_spec:foobarbaz123 || super_collection_set_specs:foobarbaz123) && document_type:item && !viewer_type:COMPOUND_PARENT_NO_VIEWER"}}]
      search = CollectionSampleSearch.new(set_spec: "foobarbaz123", solr: solr)
      search.num_found.must_equal 1
      search.items.must_equal ["123"]
      solr.verify
    end
  end
end
