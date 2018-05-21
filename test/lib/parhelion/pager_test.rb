require 'test_helper'
module Parhelion
  class PagerTest < ActiveSupport::TestCase
    describe 'when there are fewer ' do
      it 'procudes a pager' do
        # TODO: put these in describe blocks, too lazy right noa
        Pager.new.pages.must_equal([])
        (1..4).map do |page|
          Pager.new(active_page: page, rows: 25, result_count: 100).pages.must_equal([1, 2, 3, 4])
        end
        Pager.new(active_page: 4, rows: 25, result_count: 500).pages.must_equal([1, 2, 3, 4, 5, 6, 7, 8, "...", 19, 20])
        Pager.new(active_page: 6, rows: 25, result_count: 500).pages.must_equal([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, "...", 19, 20])
        Pager.new(active_page: 7, rows: 25, result_count: 500).pages.must_equal([1, 2, "...", 3, 4, 5, 6, 7, 8, 9, 10, 11, "...", 19, 20])
        Pager.new(active_page: 17, rows: 25, result_count: 500).pages.must_equal([1, 2, "...", 13, 14, 15, 16, 17, 18, 19, 20])
        Pager.new(active_page: 20, rows: 25, result_count: 500).pages.must_equal([1, 2, "...", 16, 17, 18, 19, 20])
        Pager.new(active_page: 2, rows: 25, result_count: 100).pages.must_equal([1, 2, 3, 4])
        Pager.new(active_page: 2, rows: 25, result_count: 100).display?.must_equal(true)
        Pager.new(active_page: 0, rows: 25, result_count: 0).display?.must_equal(false)
        Pager.new(active_page: 1, rows: 50, result_count: 3).pages.must_equal([])
      end
    end
  end
end
