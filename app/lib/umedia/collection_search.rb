module Umedia
  class CollectionSearch
    attr_reader :solr, :q, :page, :rows, :sort
    def initialize(q: '',
                   page: 1,
                   rows: ENV['UMEDIA_COLLECTION_PAGE_LIMIT'].to_i,
                   sort: 'collection_recency_sort desc',
                   solr: SolrClient.new.solr)
      @q    = q
      @page = page
      @rows = rows
      @solr = solr
      @sort = q.blank? ? sort : ''
    end

    def docs
      response.fetch('docs')
    end

    def num_found
      response.fetch('numFound')
    end

    private

    def response
      @response ||= query.fetch('response')
    end

    def query
      solr.paginate page, rows, 'collections', params: params
    end

    def params
      {
        q: q,
        'q.alt' => "*:*",
        fl: '*',
        sort: sort,
        fq: "document_type:collection"
      }
    end
  end
end
