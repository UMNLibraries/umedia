# frozen_string_literal: true

module Umedia
  class SortList
    include Enumerable
    attr_reader :query, :sort_query_klass, :params
    def initialize(query: Parhelion::Query.new,
                   sort_query_klass: Parhelion::SortQuery)
      @sort_query_klass = sort_query_klass
      @query = query
      @params = params
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

    def mappings
      [
        {label: 'Default Relevance', sort: 'score desc, title desc' },
        {label: 'Title: A to Z', sort: 'title asc, date_created_sort desc' },
        {label: 'Title: Z to A', sort: 'title desc, date_created_sort desc' },
        {label: 'Creator: A to Z', sort: 'creator_sort asc, title asc' },
        {label: 'Creator: Z to A', sort: 'creator_sort desc, title asc' },
        {label: 'Date: Oldest First', sort: 'date_created_sort asc, title asc' },
        {label: 'Date: Newest First', sort: 'date_created_sort desc, title asc' }
      ]
    end

    def sort_query(sort)
      sort_query_klass.new(value: sort,
                           query: query)
    end
  end
end