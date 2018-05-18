# frozen_string_literal: true

module Parhelion
  # A light wrapper around an RSolr result hash
  class Response
    attr_reader :results,
                :num_found,
                :start,
                :field_order,
                :doc_klass

    def initialize(results: [],
                   num_found: 0,
                   start: 0,
                   field_order: [],
                   doc_klass: Document)

      @results     = results
      @num_found   = num_found
      @start       = start
      @field_order = field_order
      @doc_klass   = doc_klass
    end

    def docs
      results.map do |doc|
        doc_klass.new(doc_hash: doc, field_order: field_order)
      end
    end
  end
end
