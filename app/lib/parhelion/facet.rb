# frozen_string_literal: true

module Parhelion
  class Facet
    include Enumerable
    attr_reader :rows, :name, :facet_row_klass
    def initialize(rows: [], name: '', facet_row_klass: FacetRow)
      @rows  = rows
      @name = name
      @facet_row_klass = facet_row_klass
    end

    def display?
      !rows.empty?
    end

    def ==(other)
      rows == other.rows
    end

    def each
      rows.each_slice(2).map do |row|
        yield facet_row_klass.new(value: row.first, count: row.last)
      end
    end
  end
end