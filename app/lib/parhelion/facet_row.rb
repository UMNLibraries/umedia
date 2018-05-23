# frozen_string_literal: true

module Parhelion
  class FacetRow
    attr_reader :value, :count
    def initialize(value: '', count: 0)
      @value = value
      @count = count
    end

    def ==(other)
      value == other.value && count == other.count
    end

    def to_s
      "#{value} (#{count})"
    end
  end
end
