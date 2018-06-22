# frozen_string_literal: true

module Umedia
  # Umedia search configuration
  class DocumentSearch
    attr_reader :id, :client, :document_klass
    def initialize(id: '',
                   client: SolrClient,
                   document_klass: Parhelion::Document)
      @id     = id
      @client = client
      @document_klass = document_klass
    end

    def document
      @document ||=
        document_klass.new(doc_hash: response['response']['docs'].first)
    end

    private

    def response
      client.new.solr.get 'document', params: { id: id }
    end
  end
end