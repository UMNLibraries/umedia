require 'test_helper'

module Umedia
  class CollectionCountSearchTest < ActiveSupport::TestCase
    it 'searches for a single item' do
      solr = Minitest::Mock.new
      solr.expect :get, { 'response' => { 'numFound' => 99 } }, ["select", {:params=>{:rows=>0, :q=>"record_type:primary && document_type:item && (set_spec:foo:123 || super_collection_set_specs:foo:123)"}}]
      CollectionCountSearch.new(solr: solr, set_spec: 'foo:123').to_i
      solr.verify
    end
  end
end
