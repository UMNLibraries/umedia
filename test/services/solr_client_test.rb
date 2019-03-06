require 'test_helper'

  class SolrClientTest < ActiveSupport::TestCase
    it 'returns some the default UMedia solr config' do
      client = SolrClient.new
      client.url.must_equal('http://solr_test:8983/solr/core')
      client.solr.must_be_instance_of(RSolr::Client)
    end
  end
