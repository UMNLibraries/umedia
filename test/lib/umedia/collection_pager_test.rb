require 'test_helper'

module Umedia
  class CollectionPagerTest < ActiveSupport::TestCase
    it 'produces collection pager data' do
      pager = CollectionPager.new(num_found: 107,
                                  per_page: 12,
                                  page: 3)
      pager.pages.must_equal [1, 2, 3, 4, 5, 6, 7, 8, 9]
      pager.next.must_equal 4
      pager.prev.must_equal 2
      pager.first.must_equal 1
      pager.last.must_equal 9
    end
  end
end
