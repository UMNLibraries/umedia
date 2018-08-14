require 'test_helper'

module Umedia
  class ItemSearchTest < ActiveSupport::TestCase
    it 'searches for a single item' do
      id = 9942
      item_klass = Minitest::Mock.new
      item_obj = Minitest::Mock.new
      item_klass.expect :new, item_obj, [{:doc_hash=>{:id=>"sdfsdf:sdf"}}]
      client = Minitest::Mock.new
      response = Minitest::Mock.new
      solr = Minitest::Mock.new
      client.expect :new, response, []
      response.expect :solr, solr, []
      solr.expect :get, {'response' => { 'docs' =>[{id: 'sdfsdf:sdf'}]} }, ['document', { params: { id: id } }]
      ItemSearch.new(id: id, client: client, item_klass: item_klass).item
      item_klass.verify
      item_obj.verify
      client.verify
      response.verify
      solr.verify
    end
  end
end
