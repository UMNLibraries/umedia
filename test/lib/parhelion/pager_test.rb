require 'test_helper'
module Parhelion
  class PagerTest < ActiveSupport::TestCase
    describe 'when there are fewer ' do
      it 'produces a list of pages' do
        [1].map do |page|
          p =  Pager.new(active_page: page, rows: 25, result_length: 52526).pages
          puts p.inspect
        end
        (1..8).map do |page|
          p =  Pager.new(active_page: page, rows: 25, result_length: 52526).pages
          puts p.inspect
        end

        # (2098..2102).map do |page|
        #    Pager.new(page: page, rows: 25, result_length: 52526).pages.inspect
        # end
        # (25..30).map do |page|
        #    Pager.new(page: page, rows: 25, result_length: 52526).pages.inspect
        # end

        (2098..2102).map do |page|
          p = Pager.new(active_page: page, rows: 25, result_length: 52526).pages
          puts p.inspect
        end
      #   (25..30).map do |page|
      #     p = Pager.new(active_page: page, rows: 25, result_length: 52526).pages
      #     puts p.inspect
      #   end

      #   [25].map do |page|
      #     p = Pager.new(active_page: page, rows: 25, result_length: 52526).pages
      #     puts p.inspect
      #  end
      end
    end
  end
end
