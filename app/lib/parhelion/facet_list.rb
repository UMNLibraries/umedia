# frozen_string_literal: true

module Parhelion
  # RSolr facet wrapper
  class FacetList
    include Enumerable
    attr_reader :facet_hash, :facet_klass
    def initialize(facet_hash: {},
                   facet_klass: Facet)
      @facet_hash  = facet_hash
      @facet_klass = facet_klass
    end

    def each
      facet_hash.keys.map do |name|
        yield Facet.new(rows: facet_hash[name], name: name)
      end
    end
  end
end
