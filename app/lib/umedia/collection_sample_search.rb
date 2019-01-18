module Umedia
  class CollectionSampleSearch
    attr_reader :set_spec, :solr
    def initialize(set_spec: false, solr: SolrClient.new.solr)
      raise ArgumentError.new("Required Argument: set_spec") unless set_spec
      @set_spec = set_spec
      @solr = solr
    end

    # Number of Primary Records (No Child Records)
    # Primary records are what you see in search results
    # Child records appear only in full record page views
    def num_found
      query(num_found_params).fetch('response').fetch('numFound')
    end

    # A sampling of records from primary or secondary/child pages
    def items
      query(items_params).fetch('response').fetch('docs')
    end

    def first_primary_item
      [query(primary_params).fetch('response').fetch('docs')].flatten.first
    end


    def query(params)
      solr.get 'select', params: params
    end

    def num_found_params
      params.merge(q: "#{params[:q]} && document_type:item && record_type:primary")
    end

    def primary_params
      params.merge(q: "#{params[:q]} && record_type:primary")
    end

    def items_params
      params.merge(q: "#{params[:q]} && document_type:item && !viewer_type:COMPOUND_PARENT_NO_VIEWER")
    end

    def params
      {
        rows: 3,
        fl:'*',
        sort: "featured_collection_order asc",
        q: "(set_spec:#{set_spec} || super_collection_set_specs:#{set_spec})"
      }
    end
  end
end
