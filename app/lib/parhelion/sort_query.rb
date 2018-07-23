# frozen_string_literal: true

module Parhelion
  # Encapsulates sort toggle logic
  class SortQuery
    attr_reader :value, :query
    def initialize(value: 'score desc, title desc',
                   query: Query.new)
      @value  = value
      @query  = query
    end

    def active?
      query.params['sort'] == value
    end

    def link_params
      if !active?
        query.merge('sort' => value)
      else
        query.except 'sort'
      end
    end
  end
end
