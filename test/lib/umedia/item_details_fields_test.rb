require 'test_helper'

module Umedia
  class ItemsDetailsFieldsTest < ActiveSupport::TestCase
    describe 'given an Item and a field configuration'
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
        title_field.facet.must_equal nil
        creator_field.value.must_equal 'Bill and Ted'
        creator_field.facet.must_equal 'creator_ss'
      end
    end

    def field_configs
      [
        { name: 'title' },
        { name: 'creator', facet: 'creator_ss' },
        { name: 'does_not_exist'}
      ]
    end
  end
end
