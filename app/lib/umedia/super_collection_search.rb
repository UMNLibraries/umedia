# frozen_string_literal: true

module Umedia
  # Get all of the "Super" collection names; Useful in collection indexing
  class SuperCollectionSearch
    attr_reader :solr
    def initialize(solr: SolrClient.new.solr)
      @solr = solr
    end

    def collections
      @collections ||= response.select { |facet| facet.is_a?(String) }
    end

    def response
      @response ||= solr.get('select', params:
        {
          q: 'super_collection_names:[* TO *]',
          rows: 0,
          'facet.field' => 'super_collection_name_ss',
          'facet.limit' => 100,
          'facet' => true
        })['facet_counts']['facet_fields']['super_collection_name_ss']
    end
  end
end
