module Umedia
  # A collection, plus a few example items with their thumb cofigs, and a
  # total item count
  class FeaturedCollection
    attr_reader :collection,
                :search_klass,
                :thumbnail_klass
    def initialize(collection: :MISSING_COLLECTION,
                   search_klass: CollectionSampleSearch,
                   thumbnail_klass: Thumbnail)
      @collection = collection
      @search_klass = search_klass
      @thumbnail_klass = thumbnail_klass
    end

    def to_solr
      {
        id: "collection-#{collection.set_spec}",
        document_type: 'collection',
        collection_set_spec: collection.set_spec,
        collection_collection_name: collection.display_name,
        collection_collection_description: collection.description,
        collection_item_count: collection_item_count,
        collection_thumbnails: thumbnail_config
      }
    end

    private

    def collection_item_count
      item_search.num_found
    end

    def item_search
      @item_search ||= search_klass.new(set_spec: collection.set_spec)
    end

    def thumbnail_config
      item_search.items.map do |item|
        thumb(item).to_h.merge(id: item['id'])
      end.to_json
    end

    def thumb(item)
      thumbnail_klass.new(object_url: item['object'],
                          viewer_type: item['first_viewer_type'],
                          entry_id: item['kaltura_video'])
    end
  end
end