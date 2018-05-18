require 'test_helper'

  class SolrConnectionTest < ActiveSupport::TestCase
    describe 'when using the default settings' do
      it 'returns some the default UMedia solr config' do
        solr_connection = SolrConnection.new
        solr_connection.url.must_equal('http://solr:8983/solr/test')
        solr_connection.solr.must_be_instance_of(RSolr::Client)
      end
    end
  end
