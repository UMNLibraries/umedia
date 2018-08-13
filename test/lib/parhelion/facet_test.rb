require 'test_helper'
module Parhelion
  class FacetTest < ActiveSupport::TestCase
    it 'knows its name' do
      facet = Facet.new(rows: ['UMN', 222], name: 'publisher')
      facet.name.must_equal('publisher')
    end
    it 'decomposes rsolr facet row data into FacetRow objects' do
      facet = Facet.new(rows: ['UMN', 222], name: 'publisher')
      facet.map { |f| f.must_equal(FacetRow.new(value: 'UMN', count: 222)) }
    end
    describe 'when there are no rows' do
      it 'should tell us not to display the facet' do
        facet = Facet.new(rows: [], name: 'publisher')
        facet.display?.must_equal(false)
      end
    end
    describe 'when a facet has 15 or more rows' do
      it 'indicates a more link' do
        facet = Facet.new(rows: (0...30).to_a)
        facet.more?.must_equal(true)
      end
    end
    describe 'when a facet has fewer than 15 rows' do
      it 'indicates no more link' do
        facet = Facet.new(rows: (0...29).to_a)
        facet.more?.must_equal(false)
      end
    end
  end
end