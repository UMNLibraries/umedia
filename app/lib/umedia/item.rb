# frozen_string_literal: true

module Umedia
  # Find and cache item children
  class Item
    def self.find(id, search_klass: ItemSearch)
      Rails.cache.fetch("item/#{id}") do
        search_klass.new(id: id).item
      end
    end
  end
end
