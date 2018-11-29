module Umedia
  class CollectionIndexer
    attr_reader :collections, :featured_collection_klass, :solr
    def initialize(collections: :MISSING_COLLECTIONS,
                   featured_collection_klass: FeaturedCollection,
                   solr: SolrClient.new)
      @collections = collections
      @featured_collection_klass = featured_collection_klass
      @solr = solr
    end

    def index!
      collections.map do |collection|
        solr.add(featured_collection_klass.new(collection: collection).to_solr)
      end
      solr.commit
    end
  end
end