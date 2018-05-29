require 'test_helper'

module Umedia
  class SearchTest < ActiveSupport::TestCase
    it 'passes a search configuration to the solr client ' do
      client = Minitest::Mock.new
      response = Minitest::Mock.new
      paginator = Minitest::Mock.new
      client.expect :new, response, []
      response.expect :solr, paginator, []
      paginator.expect :paginate, false, [1, 50, "search", {:params=>{:q=>"", :"q.alt"=>"*:*", :"facet.field"=>[], :"facet.limit"=>15, :fq=>["record_type:primary"], :start=>1}}]
      Search.new(q: '',
                 facet_params: {},
                 facet_fields: [],
                 rows: 50,
                 page: 1,
                 client: client).response
      client.verify
    end
  end
end
