require 'test_helper'
module Parhelion
  class ItemListTest < ActiveSupport::TestCase
    it 'produces a list of items' do
      response = {
        'responseHeader' => {'blah' => 'blah '},
        'response' => {
          'docs' => [{'title' => 'blah'}],
          'numFound' => 1,
          'start' => 0
        }
      }

      doc_hash = {'title' => 'blah', 'publisher' => 'me'}
      results = [doc_hash]
      resp = ItemList.new(results: results)
      resp.map do |doc|
        doc.must_equal Item.new(doc_hash: doc_hash)
      end
    end
  end
end
