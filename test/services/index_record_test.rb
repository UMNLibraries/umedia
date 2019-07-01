require 'test_helper'
  class IndexRecrdTest < ActiveSupport::TestCase
    it 'returns some the default UMedia solr config' do
      worker_klass = Minitest::Mock.new
      worker_klass.expect :perform_async, 'collection here', [[{:id=>:MISSING_RECORD_ID}], {:url=>"SOLR_URL"}, "CDM_ENDPOINT", "OAI_ENDPOINT", "FIELD_MAPPINGS", 1]
      IndexRecord.new(worker_klass: worker_klass,
        solr_url: 'SOLR_URL',
        cdm_endpoint: 'CDM_ENDPOINT',
        oai_endpoint: 'OAI_ENDPOINT',
        field_mappings: 'FIELD_MAPPINGS').index!
    end
  end
