require 'test_helper'

module Umedia
  class CollectionSampleItemsTest < ActiveSupport::TestCase
    it 'retrieves a set of sample items and a total primary page count for a collection' do
      response = {
        'response' => {
          'docs' => ['123'],
          'numFound' => 1
        }
      }
      solr = Minitest::Mock.new
      solr.expect :get, response, ["select", {:params=>{:rows=>3, :fl=>"*", :sort=>"featured_collection_order ASC", :q=>"set_spec:foobarbaz123 && document_type:item"}}]
      search = CollectionSampleItems.new(set_spec: "foobarbaz123", solr: solr)
      _(search.iiifables.first.doc_hash).must_equal "123"
      solr.verify
    end

    it 'retrieves sample items' do
      collection_id = "p16022coll416"
      sample = CollectionSampleItems.new(set_spec: collection_id)
      _(sample.iiifables).wont_be_empty
      for item in sample.iiifables do
	_(item.doc_hash['id']).must_match /#{collection_id}:\d+/
      end
      _(sample.contributing_organization_name).must_equal 'University of Minnesota Libraries, Kautz Family YMCA Archives.'
    end
  end
end
