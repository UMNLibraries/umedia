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
      search.iiifables.first.doc_hash.must_equal "123"
      solr.verify
    end

    it 'retrieves sample items' do
      sample = CollectionSampleItems.new(set_spec: "p16022coll99")
      sample.iiifables.map {|item| item.doc_hash['id'] }.must_equal ["p16022coll99:0", "p16022coll99:1", "p16022coll99:3"]
      sample.contributing_organization_name.must_equal 'University of Minnesota Libraries, Jean-Nickolaus Tretter Collection in Gay, Lesbian, Bisexual and Transgender Studies.'
    end
  end
end
