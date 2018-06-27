# frozen_string_literal: true

module Parhelion
  # A light wrapper around an RSolr result hash
  class DocumentList
    include Enumerable
    attr_reader :results,
                :start,
                :doc_klass

    def initialize(results: [],
                   doc_klass: Document)
      @results     = results
      @doc_klass   = doc_klass
    end

    def empty?
      results.empty?
    end

    def each(&block)
      results.each do |doc|
        yield doc_klass.new(doc_hash: doc)
      end
    end
  end
end
