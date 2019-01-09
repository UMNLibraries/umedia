module Umedia
  class CollectionIndexer
    attr_reader :collections, :featured_collection_klass, :solr, :thumbnailer_klass
    def initialize(collections: :MISSING_COLLECTIONS,
                   featured_collection_klass: FeaturedCollection,
                   solr: SolrClient.new,
                   thumbnailer_klass: Thumbnailer)
      @collections = collections
      @featured_collection_klass = featured_collection_klass
      @solr = solr
      @thumbnailer_klass = thumbnailer_klass
    end

    def index!
      collections.map do |collection|
        add(featured_collection_klass.new(collection: collection).to_h)
      end
      solr.commit
    end

    private

    def add(doc)
      return if doc.blank?
      solr.add(doc)
      upload_thumbnails(JSON.parse(doc[:collection_thumbnails]))
    end

    def upload_thumbnails(thumbs)
      thumbs.map do |thumb|
        thumbnailer_klass.new(thumb_url: thumb['url'],
                              cdn_url: thumb['cdn']).upload!
      end
    end
  end
end