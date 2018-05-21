# frozen_string_literal: true

module Parhelion
  # Generate a list of page numbers
  class Pager
    attr_reader :rows,
                :result_count,
                :active_page,
                :marker,
                :range_klass,
                :ranger

    def initialize(active_page: 1,
                   rows: 10,
                   result_count: 0,
                   marker: '...',
                   range_klass: PagerRange)
      @active_page   = active_page.to_i
      @rows          = rows
      @result_count  = result_count
      @marker        = marker
      @range_klass   = range_klass
      @ranger        = range_klass.new(last: last_page)
    end

    def display?
      pages.length.positive?
    end

    def pages
      return [] if result_count <= 1
      [
        prefix,
        mark_first,
        range_first,
        range_second,
        mark_second,
        suffix
      ].flatten.compact
    end

    def first_page
      1
    end

    def affix_length
      2
    end

    def infix_length
      4
    end

    private

    def prefix
      remove_dupes [first_page, second_page]
    end

    def suffix
      remove_dupes [penultimate_page, last_page]
    end

    # Check the range arrays to see any of our prefix/suffix numbers already
    # exist in one of those arrays and remove them if so
    def remove_dupes(affix = [])
      affix.delete_if do |page|
        range_first.include?(page) || range_second.include?(page)
      end
    end

    def range_first
      @range_first ||= ranger.from(active_page - infix_length).to(active_page)
    end

    def range_second
      # Don't show the second range if it is not needed.
      # In this case it would default to [4], so we'd have [1,2,3,4,4] returned
      # from the pages method
      return [] if range_first.last == last_page
      @range_second ||=
        ranger.from(range_first.last + 1).to(range_first.last + infix_length)
    end

    def mark_first
      mark(range_first.first > affix_length)
    end

    def mark_second
      return unless range_second.last
      mark(range_second.last < last_page)
    end

    def mark(show)
      show ? marker : nil
    end

    def second_page
      first_page + 1
    end

    def penultimate_page
      last_page - 1
    end

    def last_page
      (result_count / rows.to_f).ceil
    end
  end
end
