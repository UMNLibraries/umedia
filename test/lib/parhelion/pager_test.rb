require 'test_helper'
# TODO: yes, this test is horrible.
module Parhelion
  class PagerTest < ActiveSupport::TestCase
    describe 'when there are fewer ' do
      it 'procudes a pager' do
        # TODO: put these in describe blocks, too lazy right noa
        Pager.new.pages.must_equal([])
        Pager.new(current_page: 1, rows: 25, result_count: 100).pages.must_equal([1, 2, 3, "...", 4])
        Pager.new(current_page: 2, rows: 25, result_count: 100).pages.must_equal([1, 2, 3, 4])
        Pager.new(current_page: 3, rows: 25, result_count: 100).pages.must_equal([1, 2, 3, 4])
        Pager.new(current_page: 4, rows: 25, result_count: 100).pages.must_equal([1, 2, 3, 4])
        Pager.new(current_page: 4, rows: 25, result_count: 500).pages.must_equal([1, 2, 3, 4, 5, 6, "...", 19, 20])
        Pager.new(current_page: 6, rows: 25, result_count: 500).pages.must_equal([1, 2, "...", 4, 5, 6, 7, 8, "...", 19, 20])
        Pager.new(current_page: 7, rows: 25, result_count: 500).pages.must_equal([1, 2, "...", 5, 6, 7, 8, 9, "...", 19, 20])
        Pager.new(current_page: 17, rows: 25, result_count: 500).pages.must_equal([1, 2, "...", 15, 16, 17, 18, 19, "...", 20])
        Pager.new(current_page: 20, rows: 25, result_count: 500).pages.must_equal([1, 2, "...", 18, 19, 20])
        Pager.new(current_page: 2, rows: 25, result_count: 100).pages.must_equal([1, 2, 3, 4])
        Pager.new(current_page: 2, rows: 25, result_count: 100).display?.must_equal(true)
        Pager.new(current_page: 0, rows: 25, result_count: 0).display?.must_equal(false)
        Pager.new(current_page: 1, rows: 50, result_count: 3).pages.must_equal([])

        Pager.new(current_page: 5, rows: 50, result_count: 300).previous_page.must_equal(4)
        Pager.new(current_page: 2, rows: 50, result_count: 100).previous_page.must_equal(1)
        Pager.new(current_page: 1, rows: 50, result_count: 100).previous_page.must_equal(1)
        Pager.new(current_page: 1, rows: 50, result_count: 100).next_page.must_equal(2)
        Pager.new(current_page: 2, rows: 50, result_count: 100).next_page.must_equal(2)

        Pager.new(current_page: 1, rows: 50, result_count: 2).end_page.must_equal(2)
        Pager.new(current_page: 1, rows: 50, result_count: 100).end_page.must_equal(50)

        Pager.new(current_page: 1, rows: 50, result_count: 100).previous?.must_equal(false)
        Pager.new(current_page: 2, rows: 50, result_count: 100).previous?.must_equal(true)
        Pager.new(current_page: 1, rows: 50, result_count: 100).next?.must_equal(true)
        Pager.new(current_page: 2, rows: 50, result_count: 100).next?.must_equal(false)
      end
    end
  end
end
