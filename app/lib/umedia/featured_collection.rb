# frozen_string_literal: true

module Umedia
  # A kind of presenter for a UMedia UI element that displays collection
  # metadata. The hash produced by to_h is what the UI template uses to
  # display collection data
  class FeaturedCollection
    extend Forwardable
    def_delegators :@sample_items,
                   :iiifables,
                   :contributing_organization_name
    def_delegators :@collection,
                   :item_count,
                   :set_spec,
                   :description,
                   :display_name,
                   :super_collection?

    attr_reader :collection,
                :thumbnail_url_klass,
                :sample_klass,
                :super_sample_klass

    def initialize(collection: :MISSING_COLLECTION,
                   sample_klass: CollectionSampleItems,
                   super_sample_klass: SuperCollectionSampleItems,
                   thumbnail_url_klass: Thumbnail::Url)
      @collection = collection
      @thumbnail_url_klass = thumbnail_url_klass
      @sample_klass = sample_klass
      @super_sample_klass = super_sample_klass
      @sample_items = sample_items
    end

    def to_h
      return {} if item_count <= 0

      {
        id: "collection-#{set_spec}",
        document_type: 'collection',
        set_spec: set_spec,
        collection_name: display_name,
        collection_description: description,
        collection_item_count: item_count,
        contributing_organization_name: contributing_organization_name,
        collection_thumbnails: thumbnail_config,
        is_super_collection: super_collection?
      }
    end

    private

    def sample_items
      if super_collection?
        super_sample_klass.new(collection_name: display_name)
      else
        sample_klass.new(set_spec: set_spec)
      end
    end

    def thumbnail_config
      iiifables.map do |item|
        thumb(item).merge(id: item['id'])
      end.to_json
    end

    def thumb(item)
      thumbnail_url_klass.new(item: item,
                              iiif_thumb: true).to_h
    end
  end
end
