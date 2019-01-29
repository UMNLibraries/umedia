# frozen_string_literal: true

module Umedia
  # Get a few sample items for a given collection
  class CollectionSampleItems
    attr_reader :set_spec, :solr, :item_klass
    def initialize(set_spec: false,
                   solr: SolrClient.new.solr,
                   item_klass: Parhelion::Item)
      raise ArgumentError.new("Required Argument: set_spec") unless set_spec
      @set_spec = set_spec
      @solr = solr
      @item_klass = item_klass
    end

    # Items that have IDs which can be used to make IIIF requests
    # Pronounced "triple eye eff ables"
    def iiifables
      items.map do |item|
        # Parent item IDs can't be used with IIIF requests
        if item['viewer_type'] == 'COMPOUND_PARENT_NO_VIEWER'
          query(child_params(item)).fetch('response').fetch('docs').first
        else
          item
        end
      end.map { |item| item_klass.new(doc_hash: item) }
    end

    # Contributing Org info does not reside in compound parents but in their
    # children. So, we have to get the first child items to get this info.
    def contributing_organization_name
      first_non_compound['contributing_organization_name']
    end

    private

    def first_non_compound
      [query(non_compound_params).fetch('response').fetch('docs')].flatten.first
    end

    def items
      query(items_params).fetch('response').fetch('docs')
    end

    def query(params)
      solr.get 'select', params: params
    end

    def child_params(item)
      params.merge(q: "parent_id:\"#{item['id']}\"")
    end

    def non_compound_params
      params.merge(q: "#{items_params[:q]} && !viewer_type:COMPOUND_PARENT_NO_VIEWER")
    end

    def items_params
      params.merge(q: "#{params[:q]} && document_type:item")
    end

    def params
      {
        rows: 3,
        fl:'*',
        q: "set_spec:#{set_spec}"
      }
    end
  end
end
