require 'test_helper'
module Parhelion
  class PagerRangeTest < ActiveSupport::TestCase
    describe 'when there are no results' do
      it 'produces an empty range' do
        PagerRange.new.from().to().must_equal([])
      end
    end
    describe 'when given a negative start range' do
      it 'defaults to starting at 1' do
        PagerRange.new(last: 5).from(-1).to(5).first.must_equal(1)
      end
    end
    describe 'when given a finish beond the last item' do
      it 'defaults to starting at 1' do
        PagerRange.new(last: 5).from(1).to(15).first.must_equal(1)
      end
    end
    describe 'when given valid range data' do
      it 'procuces and range array' do
        PagerRange.new(last: 15).from(2).to(6).must_equal([2, 3, 4, 5, 6])
      end
    end
  end
end
