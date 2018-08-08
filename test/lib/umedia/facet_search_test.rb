require 'test_helper'

module Umedia
  class FacetSearchTest < ActiveSupport::TestCase
    describe 'when given no params' do
      it 'produces a default facet search configuration' do
        FacetSearch.new.config.must_equal({:"facet.field"=>[], :"facet.limit"=>15, :"facet.prefix"=>"", :"facet.sort"=>"count", :"facet.offset"=>0, :fq=>["record_type:primary"]})
      end
    end
  end
end
