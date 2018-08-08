# frozen_string_literal: true

module Umedia
  # Umedia search configuration
  class Search
    attr_reader :q, :rows, :page, :sort, :client, :facet_search
    def initialize(q: '',
                   rows: 20,
                   page: 1,
                   sort: 'score desc, title desc',
                   client: SolrClient,
                   facet_search: FacetSearch.new)
      @q            = q
      @rows         = rows
      @page         = page
      @sort         = sort
      @client       = client
      @facet_search = facet_search
    end

    def response
      @response ||= client.new.solr.paginate page, rows, 'search', params: {
        q: q,
        'q.alt': '*:*',
        sort: sort,
        rows: rows,
      }.merge(facet_search.config)
    end
  end
end