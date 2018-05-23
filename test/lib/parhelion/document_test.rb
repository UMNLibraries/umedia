require 'test_helper'
module Parhelion
  class DocumentTest < ActiveSupport::TestCase
    describe 'when given a hash of field data' do
      it 'produces a list of field objects' do
        doc_hash = { 'title' => 'foo', 'creator' => %w[blah blergh] }
        doc = Document.new(doc_hash: doc_hash,
                           field_order: %w[creator title corgi])
        doc.fields.must_equal(
          [
            Field.new(name: 'creator', value: %w[blah blergh]),
            Field.new(name: 'title', value: 'foo')
          ]
        )
      end

      it 'responds with a field when given a message prefixed with "field"' do
        doc_hash = { 'title' => 'foo', 'creator' => %w[blah blergh] }
        doc = Document.new(doc_hash: doc_hash,
                           field_order: %w[creator title corgi])
        doc.field_title.must_equal(Field.new(value: 'foo', name: 'title'))
      end

      describe 'when given a field name that does not exist' do
        it 'responds with a an empty field' do
          doc_hash = { 'title' => 'foo', 'creator' => %w[blah blergh] }
          doc = Document.new(doc_hash: doc_hash,
                            field_order: %w[creator title corgi])
          doc.field_not_gonna_happen.must_be_kind_of(MissingField)
          doc.field_not_gonna_happen.missing?.must_equal true
          doc.field_not_gonna_happen.exists?.must_equal false
        end
      end
    end
  end
end
