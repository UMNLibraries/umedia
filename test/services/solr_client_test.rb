require 'test_helper'

  class SolrClientTest < ActiveSupport::TestCase
    it 'returns some the default UMedia solr config' do
      client = SolrClient.new
      client.url.must_equal('http://solr:8983/solr/test')
      client.solr.must_be_instance_of(RSolr::Client)
    end
  end
