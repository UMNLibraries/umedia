# frozen_string_literal: true

module Umedia
  # Convert a collection into a featured collection and index it
  # And...upload a few example thumbnails for each featured collection
  class CollectionIndexer
    attr_reader :collection,
                :featured_collection_klass,
                :solr,
                :thumbnailer_klass

    def initialize(collection: :MISSING_COLLECTION,
                   featured_collection_klass: FeaturedCollection,
                   solr: SolrClient.new,
                   thumbnailer_klass: Thumbnailer)
      @collection = collection
      @featured_collection_klass = featured_collection_klass
      @solr = solr
      @thumbnailer_klass = thumbnailer_klass
    end

    def index!
      add(featured_collection_klass.new(collection: collection).to_h)
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