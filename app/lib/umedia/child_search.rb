# frozen_string_literal: true

module Umedia
  # Search for Child records
  class ChildSearch
    attr_reader :q, :fl, :parent_id, :client, :item_list_klass
    def initialize(q: '',
                   fl: 'title, id, object, parent_id, child_viewer_types, viewer_type',
                   parent_id: '',
                   client: SolrClient,
                   item_list_klass: Parhelion::ItemList)
      @q = q
      @fl = fl
      @parent_id = parent_id
      @client = client
      @item_list_klass = item_list_klass
    end

    def empty?
      response['response']['docs'].length == 0
    end

    def items
      item_list_klass.new(results: response['response']['docs'])
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
        'hl.method': 'unified',
        fq: ["parent_id:\"#{parent_id}\""],
        rows: 2000
      }
    end
  end
end
