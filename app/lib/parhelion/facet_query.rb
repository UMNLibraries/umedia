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
      query_value != {}
    end

    def query_value
      query.value_at("facets/#{field}")
    end

    def link_params
      if active?
        if without_field.empty?
          query.except 'facets'
        else
          query.merge 'facets' => without_field
        end
      else
        query.deep_merge 'facets' => { field => value }
      end
    end

    def without_field
      query.fetch('facets').except field
    end
  end
end
