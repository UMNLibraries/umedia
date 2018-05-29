# frozen_string_literal: true

module Parhelion
  # A light wrapper around an RSolr result hash
  class DocumentList
    include Enumerable
    attr_reader :results,
                :start,
                :field_order,
                :doc_klass

    def initialize(results: [],
                   field_order: [],
                   doc_klass: Document)
      @results     = results
      @field_order = field_order
      @doc_klass   = doc_klass
    end

    def each(&block)
      results.each do |doc|
        yield doc_klass.new(doc_hash: doc, field_order: field_order)
      end
    end
  end
end
