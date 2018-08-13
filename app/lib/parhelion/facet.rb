# frozen_string_literal: true

module Parhelion
  class Facet
    include Enumerable
    attr_reader :rows, :more, :name, :facet_row_klass
    def initialize(rows: [], more: 15, name: '', facet_row_klass: FacetRow)
      @rows = rows
      @more = more.to_i
      @name = name
      @facet_row_klass = facet_row_klass
    end

    #  TODO: FacetConfig contains the config that returns 15 results from solr
    # DRY this up to avoid future confusion over having to set this twice
    def more?
      rows.length / 2 >= more
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