# frozen_string_literal: true

module Parhelion
  # Generate a list of page numbers
  class Pager
    attr_reader :rows,
                :result_count,
                :current_page,
                :marker,
                :range_klass,
                :ranger

    def initialize(current_page: 1,
                   rows: 10,
                   result_count: 0,
                   marker: '...',
                   range_klass: PagerRange)
      @current_page   = current_page.positive? ? current_page : 1
      @rows          = rows
      @result_count  = result_count
      @marker        = marker
      @range_klass   = range_klass
      @ranger        = range_klass.new(last: last_page)
    end

    def start_page
      current_page == 1 ? 1 : current_page + rows
    end

    def end_page
      current_page == 1 ? rows_or_fewer : rows + rows
    end

    def rows_or_fewer
      result_count < rows ? result_count : rows
    end

    def previous_page
      previous? ? current_page - 1 : first_page
    end

    def next_page
      next? ? current_page + 1 : last_page
    end

    def previous?
      current_page - 1 >= first_page
    end

    def next?
      current_page < last_page
    end

    def display?
      pages.length.positive?
    end

    def pages
      return [] if no_pages
      [
        prefix,
        mark_first,
        range_first,
        range_second,
        mark_second,
        suffix
      ].flatten.compact
    end

    def no_pages
      last_page <= 1
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
      @range_first ||= ranger.from(current_page - infix_length).to(current_page)
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
