require 'test_helper'

module Umedia
  class FieldDataTest < ActiveSupport::TestCase
    describe 'when a record is a compound' do
      it 'finds children' do
        id = 'foo124'
        item_klass = Minitest::Mock.new
        item_klass_obj = Minitest::Mock.new
        child_klass = Minitest::Mock.new
        children_klass = Minitest::Mock.new

        item_klass.expect :find, item_klass_obj, [id]
        item_klass_obj.expect :is_compound?, true, []
        children_klass.expect :find, [child_klass], [id, {:check_exists=>false, :fq=>["translation:[* TO *]"]}]

        data = FieldData.new(id: id,
                             field: 'translation',
                             item_klass: item_klass,
                             children_klass: children_klass).items
        data.must_equal([child_klass])
        item_klass.verify
        child_klass.verify
        children_klass.verify
      end
    end

    describe 'when a record is not a compound' do
      describe 'and when the field has data' do
        it 'finds children' do
          id = 'foo124'
          item_klass = Minitest::Mock.new
          item_klass_obj = Minitest::Mock.new
          item_klass_field_obj = Minitest::Mock.new
          item_klass.expect :find, item_klass_obj, [id]
          item_klass_obj.expect :field_translation, item_klass_field_obj, []
          item_klass_field_obj.expect :value, 'stuff', []
          item_klass_obj.expect :is_compound?, false, []
          items = FieldData.new(id: id,
                              field: 'translation',
                              item_klass: item_klass).items

          items.must_equal([item_klass_obj])
          item_klass_obj.verify
          item_klass_field_obj.verify
          item_klass.verify
        end
      end
      describe 'and when the field has no data' do
        it 'finds children' do
          id = 'foo124'
          item_klass = Minitest::Mock.new
          item_klass_obj = Minitest::Mock.new
          item_klass_field_obj = Minitest::Mock.new
          item_klass.expect :find, item_klass_obj, [id]
          item_klass_obj.expect :field_translation, item_klass_field_obj, []
          item_klass_field_obj.expect :value, nil, []
          item_klass_obj.expect :is_compound?, false, []
          items = FieldData.new(id: id,
                              field: 'translation',
                              item_klass: item_klass).items

          items.must_equal([])
          item_klass.verify
        end
      end
    end
  end
end
