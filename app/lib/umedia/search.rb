# frozen_string_literal: true

module Umedia
  # Umedia search configuration
  class Search
    attr_reader :q, :facet_params, :facet_fields, :rows, :page, :client
    def initialize(q: '',
                   facet_params: {},
                   facet_fields: [],
                   rows: 50,
                   page: 1,
                   client: SolrClient)
      @q            = q
      @facet_params = facet_params
      @facet_fields = facet_fields
      @rows         = rows
      @page         = page - 1 > 0 ? page - 1 : 0
      @client       = client
    end

    def response
      @response ||= client.new.solr.paginate page, rows, 'search', params: {
        q: q,
        'q.alt': '*:*',
        'facet.field': facet_fields,
        'facet.limit': 15,
        fq: ['record_type:primary'].concat(facet_query),
        start: page
      }
    end

    def facet_query
      facet_params.keys.map do |key|
        facet_params[key].map do |param|
          "#{key}:\"#{param}\""
        end
      end.flatten
    end
  end
end