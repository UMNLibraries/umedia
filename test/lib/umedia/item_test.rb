require 'test_helper'

module Umedia
  class ItemTest < ActiveSupport::TestCase
    it 'searches for and caches and item' do
      id = 'foo124'
      search_klass = Minitest::Mock.new
      search_klass_obj = Minitest::Mock.new
      search_klass.expect :new, search_klass_obj, [{id: id}]
      search_klass_obj.expect :item, nil, []
      Item.find(id, search_klass: search_klass)
      search_klass.verify
      search_klass_obj.verify
    end
  end
end
