require 'test_helper'
module Parhelion
  class SortQueryTest < ActiveSupport::TestCase
    describe 'if no sort params exist' do
      it 'defaults to a score-based sort and is inactive' do
        params = {'q' => 'finance'}
        query =  Query.new(params: params)
        sort_query = SortQuery.new(query: query)
        _(sort_query.active?).must_equal false
        _(sort_query.link_params).must_equal({'q'=>'finance', 'sort'=>'score desc, title desc'})
      end
    end

    describe 'if a sort param exists and is the same as the sort query' do
      it 'knows it is active' do
        params = {'q' => 'finance', 'sort' => 'title asc'}
        query =  Query.new(params: params)
        sort_query = SortQuery.new(value: 'title asc', query: query)
        _(sort_query.active?).must_equal true
      end
    end
  end
end
