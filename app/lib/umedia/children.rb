# frozen_string_literal: true

module Umedia
  # Find and cache item children
  # For more robust child queries, use the ChildSearch class directly
  # TODO: consider merging ChildSearch, Children etc into Parhelion?
  class Children
    # Righ now: we only have two scenarios: check to see if there are any
    # children or return them all. If we decide to paginate, we could
    # add page to the cache key and as a variable to the search class
    def self.find(id, search_klass: ChildSearch, check_exists: false, fq: [])
      rows = check_exists ? 1 : 10_000
      Rails.cache.fetch("children/#{id}-#{rows}") do
        search_klass.new(parent_id: id, fl: '*', rows: rows, fq: fq).items
      end
    end
  end
end
