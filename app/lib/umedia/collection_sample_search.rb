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
        fl:'id, first_viewer_type, kaltura_video, object',
        q: "set_spec:#{set_spec} && document_type:item"
      }
    end
  end
end
