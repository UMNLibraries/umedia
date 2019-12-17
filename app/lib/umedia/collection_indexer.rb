# frozen_string_literal: true
require 'uri'

module Umedia
  # And...upload a few example thumbnails for each featured collection
  class CollectionIndexer
    attr_reader :featured,
                :solr,
                :thumbnailer_klass

    def initialize(collection: :MISSING_COLLECTION,
                   featured_collection_klass: FeaturedCollection,
                   solr: SolrClient.new,
                   thumbnailer_klass: Thumbnailer)
      @featured = featured_collection_klass.new(collection: collection).to_h
      @solr = solr
      @thumbnailer_klass = thumbnailer_klass
    end

    def index!
      return if featured.blank?

      solr.add(featured)
      upload_thumbnails(JSON.parse(featured[:collection_thumbnails]))
      solr.commit
    end

    private

    def upload_thumbnails(thumbs)
      thumbs.map do |thumb|
        thumbnailer_klass.new(thumb_url: URI::encode(thumb['url']),
                              cdn_url: thumb['cdn']).upload!
      end
    end
  end
end