# frozen_string_literal: true

module Umedia
  # Search for Child records
  class ChildSearch
    attr_reader :q, :fl, :parent_id, :client, :document_list_klass
    def initialize(q: '',
                   fl: 'title, id, parent_id, viewer_types, object',
                   parent_id: '',
                   client: SolrClient,
                   document_list_klass: Parhelion::DocumentList)
      @q = q
      @fl = fl
      @parent_id = parent_id
      @client = client
      @document_list_klass = document_list_klass
    end

    def empty?
      response['response']['docs'].length == 0
    end

    def documents
      document_list_klass.new(results: response['response']['docs'])
    end

    def highlighting
      response['highlighting']
    end

    private

    def response
      @response ||= client.new.solr.get 'child_search', params: {
        q: q,
        'q.alt': '*:*',
        sort: 'child_index asc',
        hl: 'on',
        fl: fl,
        hl: 'on',
        'hl.method': 'unified',
        fq: ["parent_id:\"#{parent_id}\""],
        rows: 2000
      }
    end
  end
end
