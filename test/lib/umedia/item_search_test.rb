require 'test_helper'

module Umedia
  class DocumentSearchTest < ActiveSupport::TestCase
    it 'searches for a single document' do
      id = 9942
      document_klass = Minitest::Mock.new
      document_obj = Minitest::Mock.new
      document_klass.expect :new, document_obj, [{:doc_hash=>{:id=>"sdfsdf:sdf"}}]
      client = Minitest::Mock.new
      response = Minitest::Mock.new
      solr = Minitest::Mock.new
      client.expect :new, response, []
      response.expect :solr, solr, []
      solr.expect :get, {'response' => { 'docs' =>[{id: 'sdfsdf:sdf'}]} }, ['document', { params: { id: id } }]
      doc = DocumentSearch.new(id: id, client: client, document_klass: document_klass).document
      document_klass.verify
      document_obj.verify
      client.verify
      response.verify
      solr.verify
    end
  end
end
