require 'test_helper'
module Parhelion
  class FacetRowTest < ActiveSupport::TestCase
    it 'knows its value and count' do
      facet = FacetRow.new(value: 'UMN', count: 122)
      facet.value.must_equal('UMN')
      facet.count.must_equal(122)
    end
    it 'knows how to stringify itself for display' do
      facet = FacetRow.new(value: 'UMN', count: 122)
      facet.to_s.must_equal("UMN (122)")
    end
  end
end