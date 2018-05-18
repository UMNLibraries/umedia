# frozen_string_literal: true

module Parhelion
  # Gaurd against negative start ranges and end ranges larger than the last
  # number of pages
  class PagerRange
    attr_reader :start, :finish, :last
    def initialize(last: 0)
      @last = last
    end

    def from(start = 0)
      @start = start
      self
    end

    def to(finish = 0)
      @finish = finish
      to_a
    end

    private

    def valid_start
      if start < 1
        1
      elsif start > last
        last
      else
        start
      end
    end

    def valid_finish
      if finish > last
        last
      else
        finish
      end
    end

    def to_a
      return [] if last.zero?
      (valid_start..valid_finish).to_a
    end
  end
end
