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
      results = [doc_hash]
      resp = DocumentList.new(results: results)
      resp.map do |doc|
        doc.must_equal Document.new(doc_hash: doc_hash)
      end
    end
  end
end
