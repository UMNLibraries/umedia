require 'test_helper'
module Parhelion
  class DocumentListTest < ActiveSupport::TestCase
    it 'produces a list of documents' do
      response = {
        'responseHeader' => {'blah' => 'blah '},
        'response' => {
          'docs' => [{'title' => 'blah'}],
          'numFound' => 1,
          'start' => 0
        }
      }

      doc_hash = {'title' => 'blah', 'publisher' => 'me'}
      field_order = %w[publisher title]
      results = [doc_hash]
      resp = DocumentList.new(results: results,
                          field_order: field_order)
      resp.map do |doc|
        doc.must_equal Document.new(doc_hash: doc_hash,
                                    field_order: field_order)
      end

    end
  end
end
