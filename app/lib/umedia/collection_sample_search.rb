module Umedia
  class CollectionSampleSearch
    attr_reader :set_spec, :solr
    def initialize(set_spec: false, solr: SolrClient.new.solr)
      raise ArgumentError.new("Required Argument: set_spec") unless set_spec
      @set_spec = set_spec
      @solr = solr
    end

    def num_found
      query.fetch('response').fetch('numFound')
    end

    def items
      query.fetch('response').fetch('docs')
    end

    private

    def query
      solr.get 'select', params: params
    end

    def params
      {
        rows: 3,
        fl:'*',
        sort: "featured_collection_order asc",
        q: "(set_spec:#{set_spec} || super_collection_set_specs:#{set_spec})  && !document_type:collection && !viewer_type:COMPOUND_PARENT_NO_VIEWER"
      }
    end
  end
end
