require 'test_helper'

module Umedia
  class ChildSearchTest < ActiveSupport::TestCase
    it 'searches for children of a item' do
      parent_id = 9942
      q = ''
      item_list_klass = Minitest::Mock.new
      item_list_obj = Minitest::Mock.new
      item_list_klass.expect :new, [{foo: 'bar'}], [{:results=>[{:id=>"sdfsdf:sdf"}]}]
      client = Minitest::Mock.new
      response = Minitest::Mock.new
      solr = Minitest::Mock.new
      client.expect :new, response, []
      response.expect :solr, solr, []
      search_params = {:q=>"", :sort=>"child_index asc", :hl=>"on", :fl=>"title, id, object, parent_id, first_viewer_type, viewer_type, child_index", :"hl.method"=>"unified", :fq=>["parent_id:\"9942\""]}
      solr_args = [1, 3, "child_search", {:params=>search_params}]
      solr.expect :paginate, {'highlighting' => 'highlighting here', 'response' => { 'numFound' => 1, 'docs' =>[{id: 'sdfsdf:sdf'}]} }, solr_args

      search_config = Minitest::Mock.new
      search_config.expect :to_h, search_params, []
      search_config.expect :page, 1, []
      search_config.expect :rows, 3, []
      search_config.expect :fq, [], []

      search = ChildSearch.new(parent_id: parent_id, search_config: search_config, client: client, item_list_klass: item_list_klass)
      _(search.items).must_equal [{:foo=>"bar"}]
      _(search.empty?).must_equal false
      _(search.num_found).must_equal 1

      _(search.highlighting).must_equal 'highlighting here'
      item_list_klass.verify
      client.verify
      response.verify
      solr.verify
      search_config.verify
    end

    describe 'when initialized without a parent id' do
      it 'raises an argument error' do
        _(->{ ChildSearch.new() }).must_raise ArgumentError
      end
    end
  end
end
