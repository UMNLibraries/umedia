require 'test_helper'

module Umedia
  class SearchTest < ActiveSupport::TestCase
    it 'passes a search configuration to the solr client' do
      client = Minitest::Mock.new
      response = Minitest::Mock.new
      paginator = Minitest::Mock.new
      client.expect :new, response, []
      response.expect :solr, paginator, []
      paginator.expect :paginate, false,
      [1, 50, "search", {:params=>{:q=>"", :"q.alt"=>"*:*", :sort=>"score desc, title desc", :rows=>50, "facet.field"=>:MISSING_FACET_FIELDS, "facet.limit"=>15, "facet.prefix"=>"", "facet.sort"=>"count", "facet.offset"=>0, :fq=>["record_type:primary"]}}]

      Search.new(q: '',
                 rows: 50,
                 page: 1,
                 client: client).response
      client.verify
    end
  end
end
