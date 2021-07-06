require 'test_helper'
module Parhelion
  class SearchConfigTest < ActiveSupport::TestCase
    describe 'when all params are present' do
      it 'includes them all in its hash output' do
        config = SearchConfig.new(
          q: 'stuff',
          fq: ['blergh:blargh'],
          fl: '*',
          rows: 20,
          page: 1,
          sort: 'score desc, title desc'
        )

        _(config.to_h).must_equal({:q=>"stuff", :fl=>"*", :sort=>"score desc, title desc"})
        _(config.to_s).must_equal "@q@fl=*@fq=[\"blergh:blargh\"]@sort=score desc, title desc@rows=20@page=1"
        _(config.hash).must_equal "c9048714af510ad29acb1153a91c8e15d3ca2b0e"
      end
    end

    describe 'when not all params are present' do
      it 'skips empties its hash output' do
        config = SearchConfig.new(
          fl: '*',
          rows: 20,
          page: 1,
          sort: 'score desc, title desc'
        )

        _(config.to_h).must_equal({:fl=>"*", :sort=>"score desc, title desc"})
        _(config.to_s).must_equal "@q@fl=*@fq=[]@sort=score desc, title desc@rows=20@page=1"
        _(config.hash).must_equal "6baadbcc92d720fa4e2daed4f6c56c70e7f476d4"
      end
    end
  end
end
