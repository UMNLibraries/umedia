module Umedia
  class CollectionSearch
    attr_reader :solr, :page, :rows, :sort
    def initialize(page: page,
                   rows: 12,
                   sort: 'set_spec desc',
                   solr: SolrClient.new.solr)
      @solr = solr
      @page = page
      @rows = rows
      @sort = sort
    end

    def docs
      query.fetch('response').fetch('docs')
    end

    def num_found
      query.fetch('response').fetch('numFound')
    end

    private

    def query
      solr.paginate page, 6, 'collections', params: params
    end

    def params
      {
        rows: rows,
        'q.alt' => "*:*",
        fl: '*',
        page: page,
        sort: "is_super_collection desc, #{sort}",
        fq: "document_type:collection"
      }
    end
  end
end
