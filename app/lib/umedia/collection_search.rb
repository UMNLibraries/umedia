module Umedia
  class CollectionSearch
    attr_reader :solr
    def initialize(solr: SolrClient.new.solr)
      @solr = solr
    end

    def docs
      query.fetch('response').fetch('docs')
    end

    private

    def query
      solr.get 'collections', params: params
    end

    def params
      {
        rows: 10_000,
        q: "*:*"
      }
    end
  end
end
