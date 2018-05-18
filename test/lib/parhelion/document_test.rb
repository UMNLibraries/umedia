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
    end
  end
end
