require 'test_helper'

module Umedia
  class CollectionSearchTest < ActiveSupport::TestCase
    it 'searches for' do
      response = {'response' => {'numFound' => 99, 'docs' => ['foo', 'bar'] } }
      solr = Minitest::Mock.new
      solr.expect :paginate, response, [1, 20, "collections", {:params=>{:q=>"stuff", "q.alt"=>"*:*", :fl=>"*", :fq=>"document_type:collection"}}]
      search = CollectionSearch.new(
        q: 'stuff',
        solr: solr
      )
      search.num_found.must_equal 99
      search.docs.must_equal ["foo", "bar"]
      solr.verify
    end
  end
end
