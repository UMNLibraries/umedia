# frozen_string_literal: true

module Umedia
  class RecordCountSearch
    attr_reader :solr
    def initialize(solr: SolrClient.new.solr)
      @solr = solr
    end

    def count
      response["response"]["numFound"]
    end

    def response
      @response ||= solr.get 'select', :params => { :q => 'record_type:"primary"', rows: 0 }
    end
  end
end