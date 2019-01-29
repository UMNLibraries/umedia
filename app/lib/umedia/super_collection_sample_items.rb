# frozen_string_literal: true

module Umedia
  # Get a few sample items for a given collection
  class SuperCollectionSampleItems
    attr_reader :ids, :solr, :item_klass
    def initialize(collection_name: :MISSING_COLLECTION_NAME,
                   super_collections: SuperCollections,
                   solr: SolrClient.new.solr,
                   item_klass: Parhelion::Item)
      @ids = super_collections.new.item_ids_for(collection_name)
      @solr = solr
      @item_klass = item_klass
    end

    # Items that have IDs which can be used to make IIIF requests
    # Pronounced "triple eye eff ables"
    def iiifables
      @iiifables ||= result.map { |item| item_klass.new(doc_hash: item) }
    end

    def contributing_organization_name
      'Items collected from multiple contributing organizations.'
    end

    private

    def result
      query.fetch('response').fetch('docs')
    end

    def query
      solr.get 'select', params: params
    end

    def params
      {
        rows: 3,
        fl:'*',
        q: ids.map { |id| "id:\"#{id}\"" }.join(' || ')
      }
    end
  end
end
