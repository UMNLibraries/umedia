# frozen_string_literal: true

module Parhelion
  # Encapsulates facet upsert logic
  class FacetQuery
    attr_reader :field, :value, :query
    def initialize(field: '', value: '', query: Query.new)
      @query = query
      @field = field
      @value = value
    end

    def active?
      query_values.include? value
    end

    def link_params
      if !current_link.fetch('facets', []).empty?
        sanitized_query.merge current_link
      else
        sanitized_query.except 'facets'
      end
    end

    # Facet links must reset paging
    def sanitized_query
      query.except('page')
    end

    private

    def query_values
      [facets.fetch(field, [])].flatten
    end

    def facets
      sanitized_query.fetch('facets', {})
    end


    def current_link
      active? ? facets_without_value : facets_with_value
    end

    def facets_with_value
      { 'facets' => facets.merge(field => (query_values << value).uniq) }
    end

    def facets_without_value
      return facets_without_field if without_value == []
      { 'facets' => facets.merge(field => without_value) }
    end

    def facets_without_field
      { 'facets' => facets.except(field) }
    end

    def without_value
      query_values.reject { |val| val == value }
    end
  end
end
