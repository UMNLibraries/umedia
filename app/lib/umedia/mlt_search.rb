# frozen_string_literal: true

module Umedia
  # Umedia search configuration
  class MltSearch
    attr_reader :id, :client, :item_klass
    def initialize(id: '',
                   client: SolrClient,
                   item_klass: Parhelion::Item)
      @id     = id
      @client = client
      @item_klass = item_klass
    end

    def items
      matches.map { |match| item_klass.new(doc_hash: match) }
    end

    private

    def matches
      response.fetch('match', {}).fetch('docs', [])
    end

    def response
      client.new.solr.get 'mlt', params: { q: "id:\"#{id}\"" }
    end
  end
end