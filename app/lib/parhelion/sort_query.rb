# frozen_string_literal: true

module Parhelion
  # Encapsulates sort toggle logic
  class SortQuery
    attr_reader :asc, :desc, :query
    def initialize(asc: :missing_asc, desc: :missing_desc, query: Query.new)
      @asc   = asc
      @desc  = desc
      @query = query
    end

    def is_ascending?
      query.fetch('sort') == asc
    end

    def is_active?
      sort_params == asc || sort_params == desc
    end

    def link_params
      if is_ascending?
        query.merge 'sort' => desc
      else
        query.merge 'sort' => asc
      end
    end

    private

    def sort_params
      query.fetch('sort', '')
    end
  end
end
