# frozen_string_literal: true

module Umedia
  # Handle pager data for collections
  class CollectionPager
    attr_reader :num_found, :page, :per_page
    def initialize(num_found: 0, page: 1, per_page: 12)
      @num_found = num_found
      @page = page
      @per_page = per_page
    end

    def pages
      @pages ||= (1..((num_found / per_page) + 1)).to_a
    end

    def next
      next_page <= pages.last ? next_page : page
    end

    def prev
      prev_page >= 1 ? prev_page : 1
    end

    def first
      1
    end

    def last
      pages.last
    end

    private

    def prev_page
      page - 1
    end

    def next_page
      page + 1
    end
  end
end