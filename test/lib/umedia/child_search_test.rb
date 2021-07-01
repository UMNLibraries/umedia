require 'test_helper'

module Umedia
  class ChildSearchTest < ActiveSupport::TestCase
    it 'searches for children of a item' do
      parent_id = 9942
      q = ''
      item_list_klass = mock()
      item_list_obj = mock()
      item_list_klass.expects(:new).with({:results=>[{:id=>"sdfsdf:sdf"}]}).returns([{foo: 'bar'}]) 
      client = mock()
      response = mock()
      solr = mock()
      client.expects(:new).returns(response)
      response.expects(:solr).returns(solr)
      search_params = {:q=>"", :sort=>"child_index asc", :hl=>"on", :fl=>"title, id, object, parent_id, first_viewer_type, viewer_type, child_index", :"hl.method"=>"unified", :fq=>["parent_id:\"9942\""]}
      solr_args = [1, 3, "child_search", {:params=>search_params}]
      solr.expects(:paginate).with(solr_args).returns({'highlighting' => 'highlighting here', 'response' => { 'numFound' => 1, 'docs' =>[{id: 'sdfsdf:sdf'}]}})

      search_config = mock()
      search_config.expects(:to_h).returns(search_params)
      search_config.expects(:page).returns(1)
      search_config.expects(:rows).returns(3)
      search_config.expects(:fq)

      search = ChildSearch.new(parent_id: parent_id, search_config: search_config, client: client, item_list_klass: item_list_klass)
      _(search.items).must_equal [{:foo=>"bar"}]
      _(search.empty?).must_equal false
      _(search.num_found).must_equal 1

      _(search.highlighting).must_equal 'highlighting here'
    end

    describe 'when initialized without a parent id' do
      it 'raises an argument error' do
        _(->{ ChildSearch.new() }).must_raise ArgumentError
      end
    end
  end
end
