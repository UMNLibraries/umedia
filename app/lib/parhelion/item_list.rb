# frozen_string_literal: true

module Parhelion
  # A light wrapper around an RSolr result hash
  class ItemList
    include Enumerable
    attr_reader :results,
                :start,
                :item_klass

    def initialize(results: [],
                   item_klass: Item)
      @results     = results
      @item_klass  = item_klass
    end

    def empty?
      results.empty?
    end

    def each(&block)
      results.each do |doc|
        yield item_klass.new(doc_hash: doc)
      end
    end
  end
end
