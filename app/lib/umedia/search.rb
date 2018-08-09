# frozen_string_literal: true

module Umedia
  # Umedia search configuration
  class Search
    attr_reader :q, :fl, :rows, :page, :sort, :client, :facet_config
    def initialize(q: '',
                   rows: 20,
                   fl: false,
                   page: 1,
                   sort: 'score desc, title desc',
                   client: SolrClient,
                   facet_config: FacetSearch.new.config)
      @q = q
      @rows = rows
      @page = page
      @sort = sort
      @client = client
      @facet_config = facet_config
    end

    def response
      @response ||= client.new.solr.paginate page, rows, 'search', params: {
        q: q,
        'q.alt': '*:*',
        sort: sort,
        rows: rows,
      }.merge(facet_config).merge(fl_config)
    end

    def fl_config
      if fl
        { fl: fl }
      else
        {}
      end
    end
  end
end