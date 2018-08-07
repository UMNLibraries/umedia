require 'test_helper'

module Umedia
  class ItemsDetailsFieldsTest < ActiveSupport::TestCase
    describe 'given an Item and a field configuration' do
      it 'produces a list of field values' do
        item = Parhelion::Item.new(doc_hash: {
            'id' => 'p16022coll142:147',
            'title' => 'This is a title',
            'creator' => 'Bill and Ted',
            'contributor' => ''
          })
        displayables = ItemDetailsFields.new(field_configs: field_configs,
                                              item: item).displayables
        title_field = displayables[0]
        creator_field = displayables[1]
        displayables.length.must_equal 2
        title_field.value.must_equal 'This is a title'
        title_field.facet.must_equal false
        creator_field.value.must_equal 'Bill and Ted'
        creator_field.facet.must_equal 'creator'
      end
    end

    def field_configs
      [
        { name: 'title' },
        { name: 'creator', facet: true },
        { name: 'does_not_exist'}
      ]
    end
  end
end
