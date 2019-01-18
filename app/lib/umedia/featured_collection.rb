module Umedia
  # A collection, plus a few example items with their thumb cofigs, and a
  # total item count
  class FeaturedCollection
    attr_reader :collection,
                :super_collections,
                :search_klass,
                :thumbnail_url_klass,
                :item_klass
    def initialize(collection: :MISSING_COLLECTION,
                   search_klass: CollectionSampleSearch,
                   thumbnail_url_klass: Thumbnail::Url,
                   item_klass: Parhelion::Item,
                   super_collections: SuperCollectionSearch.new.collections)
      @collection = collection
      @super_collections = super_collections
      @search_klass = search_klass
      @thumbnail_url_klass = thumbnail_url_klass
      @item_klass = item_klass
    end

    def to_h
      return {} unless item_count > 0
      {
        id: "collection-#{collection.set_spec}",
        document_type: 'collection',
        set_spec: collection.set_spec,
        collection_name: collection.display_name,
        collection_description: collection.description,
        collection_item_count: item_count,
        contributing_organization_name: contributing_organization_name,
        collection_thumbnails: thumbnail_config,
        is_super_collection: super_collection?
      }
    end

    private

    def super_collection?
      super_collections.include? collection.display_name
    end

    def item_count
      @item_count ||= item_search.num_found
    end

    def items
      @items ||= item_search.items
    end

    def contributing_organization_name
      item_search.first_primary_item['contributing_organization_name']
    end

    def item_search
      @item_search ||= search_klass.new(set_spec: collection.set_spec)
    end

    def thumbnail_config
      items.map do |item|
        thumb(item).merge(id: item['id'])
      end.to_json
    end

    def thumb(item)
      thumbnail_url_klass.new(item: item_klass.new(doc_hash: item),
                              iiif_thumb: true).to_h
    end
  end
end