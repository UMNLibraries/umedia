require 'test_helper'
module Parhelion
  class SortQueryTest < ActiveSupport::TestCase
    describe 'if no sort params exist' do
      it 'defaults to an ascending sort' do
        params = {'q' => 'finance'}
        query =  Query.new(params: params)
        sort = SortQuery.new(asc: 'title_asc', desc: 'title_desc', query: query)
        sort.link_params.must_equal({'q'=>'finance', 'sort'=>'title_asc'})
      end
    end

    describe 'if sort is ascending' do
      it 'switches to a descending sort' do
        params = {'q' => 'finance', 'sort' => 'title_asc'}
        query =  Query.new(params: params)
        sort = SortQuery.new(asc: 'title_asc', desc: 'title_desc', query: query)
        sort.link_params.must_equal('q' => 'finance', 'sort' => 'title_desc')
      end
    end
  end
end