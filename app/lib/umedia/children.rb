# frozen_string_literal: true

module Umedia
  # Find and cache item children
  class Children
    def self.find(id, search_klass: ChildSearch)
      Rails.cache.fetch("children/#{id}") do
        search_klass.new(parent_id: id, fl: '*').items
      end
    end
  end
end
