require 'test_helper'

module Umedia
  module Citation
    class CitationTest < ActiveSupport::TestCase
      it 'produces a citation' do
        class FakeFormatter
          def self.format(value)
            "(#{value})"
          end
        end
        mappings = [{
          name: 'creator',
          prefix: 'WOWO',
          suffix: '.',
          formatters: [FakeFormatter]
        }]
        doc = Minitest::Mock.new
        doc_field = Minitest::Mock.new
        doc.expect 'field_creator.value', 'Ted', []
        cite = Cite.new(doc: doc, mappings: mappings)
        cite.to_s.must_equal 'WOWO(Ted).'
      end
    end
  end
end
