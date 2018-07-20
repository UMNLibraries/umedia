require 'test_helper'

module Umedia
  class ChildSearchTest < ActiveSupport::TestCase
    it 'searches for children of a document' do
      parent_id = 9942
      q = ''
      document_list_klass = Minitest::Mock.new
      document_list_obj = Minitest::Mock.new
      document_list_klass.expect :new, [{foo: 'bar'}], [{:results=>[{:id=>"sdfsdf:sdf"}]}]
      client = Minitest::Mock.new
      response = Minitest::Mock.new
      solr = Minitest::Mock.new
      client.expect :new, response, []
      response.expect :solr, solr, []
      solr.expect :get, {'highlighting' => 'highlighting here', 'response' => { 'docs' =>[{id: 'sdfsdf:sdf'}]} }, ["child_search", {:params=>{:q=>"", :"q.alt"=>"*:*", :sort=>"child_index asc", :hl=>"on", :fl=>"title, id, parent_id, child_viewer_types, object", :"hl.method"=>"unified", :fq=>["parent_id:\"9942\""], :rows=>2000}}]
      search = ChildSearch.new(q: '', parent_id: parent_id, client: client, document_list_klass: document_list_klass)
      search.documents.must_equal [{:foo=>"bar"}]
      search.highlighting.must_equal 'highlighting here'
      document_list_klass.verify
      client.verify
      response.verify
      solr.verify
    end
  end
end
