# frozen_string_literal: true

module Umedia
  # Provides a total count of primary records for a collection or a super
  # collection
  class CollectionCountSearch
    attr_reader :set_spec, :solr
    def initialize(set_spec: :MISSING_SET_SPEC, solr: SolrClient.new.solr)
      @set_spec = set_spec
      @solr = solr
    end

    # Number of Primary Records (No Child Records)
    # Primary records are what you see in search results
    # Child records appear only in full record page views
    def to_i
      result.fetch('response').fetch('numFound').to_i
    end

    private

    def result
      solr.get 'select', params: { rows: 0, q: query }
    end

    def query
      [
        'record_type:primary',
        'document_type:item',
        "(set_spec:#{set_spec} || super_collection_set_specs:#{set_spec})"
      ].join(' && ')
    end
  end
end
