require 'test_helper'

module Umedia
  class FacetCountTest < ActiveSupport::TestCase
    it 'provides count totals for a given field based on facet results' do
      response = { 'facet_counts' => { 'facet_fields' => { 'made_up_field' => ['blah', '123', 'another thing', '99'] }}}
      solr = Minitest::Mock.new
      solr.expect :get, response, ["select", {:params=>{:q=>"*:*", :rows=>0, :facet=>true, :"facet.field"=>"made_up_field", :"facet.limit"=>-1, :fl=>""}}]
      search = FacetCountSearch.new(solr: solr, facet: 'made_up_field')
      search.count.must_equal 2
      solr.verify
    end
  end
end
