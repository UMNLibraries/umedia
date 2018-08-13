require 'test_helper'

module Umedia
  class FacetConfigTest < ActiveSupport::TestCase
    describe 'when given no params' do
      it 'produces a default facet search configuration' do
        FacetConfig.new(fields: ['foo']).config.must_equal(
          {"facet.field"=>["foo"], "facet.limit"=>15, "facet.prefix"=>"", "facet.sort"=>"count", "facet.offset"=>0, :fq=>["record_type:primary"]}
        )
      end
    end
  end
end
