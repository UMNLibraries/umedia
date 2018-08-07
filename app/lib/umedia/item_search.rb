# frozen_string_literal: true

module Umedia
  # Umedia search configuration
  class ItemSearch
    attr_reader :id, :client, :item_klass
    def initialize(id: '',
                   client: SolrClient,
                   item_klass: Parhelion::Item)
      @id     = id
      @client = client
      @item_klass = item_klass
    end

    def item
      @item ||=
      item_klass.new(doc_hash: response['response']['docs'].first)
    end

    private

    def response
      client.new.solr.get 'document', params: { id: id }
    end
  end
end