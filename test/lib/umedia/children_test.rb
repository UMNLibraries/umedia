require 'test_helper'

module Umedia
  class ItemTest < ActiveSupport::TestCase
    it 'searches for and caches item children' do
      id = 'foo124'
      search_klass = Minitest::Mock.new
      search_klass_obj = Minitest::Mock.new
      search_klass.expect :new, search_klass_obj, [{:parent_id=>"foo124", fl: '*'}]
      search_klass_obj.expect :items, nil, []
      Children.find(id, search_klass: search_klass)
      search_klass.verify
      search_klass_obj.verify
    end
  end
end
