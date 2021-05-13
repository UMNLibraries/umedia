require 'test_helper'

module Umedia
  class CollectionTest < ActiveSupport::TestCase
    describe 'when its name matches a super collection name' do
      it 'knows it is a super collection and its item count' do
        set_spec = 'foo:123'
        collection_count_klass = Minitest::Mock.new
        collection_count_klass_obj = Minitest::Mock.new
        collection_count_klass.expect :new, collection_count_klass_obj, [{:set_spec=>"foo:123"}]
        collection_count_klass_obj.expect :to_i, 109, []

        collection = Collection.new(set_spec: set_spec,
                                    name: 'ul_ugly123thing - Revealing Bound Maps',
                                    description: 'bar',
                                    collection_count_klass: collection_count_klass)
        _(collection.name).must_equal 'ul_ugly123thing - Revealing Bound Maps'
        _(collection.display_name).must_equal 'Revealing Bound Maps'
        _(collection.description).must_equal 'bar'
        _(collection.super_collection?).must_equal true
        _(collection.set_spec).must_equal 'foo:123'
        _(collection.item_count).must_equal 109
        collection_count_klass.verify
        collection_count_klass_obj.verify
      end
    end

    describe 'when its name does not matche a super collection name' do
      it 'knows it is not a super collection' do
        collection = Collection.new(set_spec: 'foo:123',
                                    name: 'ul_ugly123thing - foo - bar',
                                    description: 'bar')
        _(collection.name).must_equal 'ul_ugly123thing - foo - bar'
        _(collection.display_name).must_equal 'foo - bar'
        _(collection.description).must_equal 'bar'
        _(collection.super_collection?).must_equal false
        _(collection.set_spec).must_equal 'foo:123'
      end
    end
  end
end
