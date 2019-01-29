# frozen_string_literal: true

module Umedia
  class SortList
    include Enumerable
    attr_reader :query, :sort_query_klass, :params, :mappings
    def initialize(query: Parhelion::Query.new,
                   sort_query_klass: Parhelion::SortQuery,
                   mappings: false)
      @sort_query_klass = sort_query_klass
      @query = query
      @params = params
      @mappings = mappings ? mappings : default_mappings
    end

    def active_label
      (active) ? active[:label] : mappings.first[:label]
    end

    def each
      mappings.map do |mapping|
        yield mapping.merge(query: sort_query(mapping[:sort]))
      end
    end

    def active
      self.select { |sort| sort[:query].active? }.first
    end

    private

    def default_mappings
      [
        {label: 'Relevance', sort: 'score desc, title_s desc' },
        {label: 'Title: A to Z', sort: 'title_s asc, date_created_sort desc' },
        {label: 'Title: Z to A', sort: 'title_s desc, date_created_sort desc' },
        {label: 'Creator: A to Z', sort: 'creator_sort asc, title_s asc' },
        {label: 'Creator: Z to A', sort: 'creator_sort desc, title_s asc' },
        {label: 'Date: Oldest First', sort: 'date_created_sort asc, title_s asc' },
        {label: 'Date: Newest First', sort: 'date_created_sort desc, title_s asc' }
      ]
    end

    def sort_query(sort)
      sort_query_klass.new(value: sort,
                           query: query)
    end
  end
end