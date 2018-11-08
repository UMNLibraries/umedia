# frozen_string_literal: true

module Umedia
  # Find and cache item children
  # For more robust child queries, use the ChildSearch class directly
  # TODO: consider merging ChildSearch, Children etc into Parhelion?
  class Children
    extend Forwardable

    def_delegator :@search, :empty?

    attr_reader :parent_id, :search
    def initialize(parent_id: :MISSING_PARENT_ID,
                   check_exists: false,
                   fq: [],
                   search_config_klass: Parhelion::SearchConfig,
                   search_klass: ChildSearch)

      @parent_id = parent_id
      @search_klass = search_klass
      # Right now: we only have two scenarios: check to see if there are any
      # children or return them all. If we decide to paginate, we could
      # add page to the cache key and as a variable to the search class
      # Setting rows to zero returns no docs but numFound will be non-zero
      search_config = search_config_klass.new(fq: fq,
                                              rows: check_exists ? 0 : 10_000,
                                              fl: '*')
      @search = search_klass.new(parent_id: parent_id,
                                 search_config: search_config)
    end

    def find
      Rails.cache.fetch(cache_key) { search.items }
    end

    def cache_key
      "children/#{parent_id}/#{search.hash}"
    end
  end
end
