require 'test_helper'
module Parhelion
  class ItemTest < ActiveSupport::TestCase

    it 'knows its url' do
      item_id = 'foobar2:444'
      doc_hash = {'id' => item_id}
      item = Item.new(doc_hash: doc_hash)
      _(item.url).must_equal "#{ENV.fetch('RAILS_BASE_URL')}/item/#{item_id}"
    end

    describe 'when it has childern' do
      # Usually, we don't request height/width of a parent
      it 'produces correct height and width of zero' do
        VCR.use_cassette('item_test_p16022coll142:147') do
          doc_hash = { 'id' => 'p16022coll142:147', 'page_count' => 50, 'viewer_type' => 'COMPOUND_PARENT_NO_VIEWER' }
          item = Item.new(doc_hash: doc_hash)
          _(item.height).must_equal(0)
          _(item.width).must_equal(0)
        end
      end
    end

    describe 'when it does not have childern' do
      it 'produces correct height and width' do
        VCR.use_cassette('item_test_p16022coll122:0') do
          item = Item.new(doc_hash: { 'id' => 'p16022coll122:0'})
          _(item.height).must_equal(4961)
          _(item.width).must_equal(2115)
        end
      end
    end

    describe 'when it has a parent id' do
      it 'is its own parent' do
        doc_hash = { 'id' => 'fooCollection:1235', 'parent_id' => 'fooCollection:1232' }
        item = Item.new(doc_hash: doc_hash)
        _(item.parent_id).must_equal(doc_hash['parent_id'].split(':').last)
      end
    end

    describe 'when given a hash of field data' do
      it 'knows its IDs' do
        doc_hash = { 'id' => 'fooCollection:123', 'title' => 'foo', 'creator' => %w[blah blergh] }
        item = Item.new(doc_hash: doc_hash)
        _(item.id).must_equal('123')
        _(item.collection).must_equal('fooCollection')
      end

      it 'knows that it is a compound' do
        doc_hash = { 'title' => 'foo', 'creator' => %w[blah blergh] }
        item = Item.new(doc_hash: doc_hash)
        _(item.is_compound?).must_equal(false)
      end

      it 'knows that it is a compound' do
        doc_hash = { 'title' => 'foo', 'creator' => %w[blah blergh], 'types' => ['Still Image'] }
        item = Item.new(doc_hash: doc_hash)
        _(item.type).must_equal('Still Image')
      end

      it 'responds with a field when given a message prefixed with "field"' do
        doc_hash = { 'title' => 'foo', 'creator' => %w[blah blergh] }
        item = Item.new(doc_hash: doc_hash)
        _(item.field_title).must_equal(Field.new(value: 'foo', name: 'title'))
      end

      describe 'when given a field name that does not exist' do
        it 'responds with a an empty field' do
          doc_hash = { 'title' => 'foo', 'creator' => %w[blah blergh] }
          item = Item.new(doc_hash: doc_hash)
          _(item.field_not_gonna_happen).must_be_kind_of(MissingField)
          _(item.field_not_gonna_happen.exists?).must_equal false
        end
      end
    end
  end
end
