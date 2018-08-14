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
        field = Minitest::Mock.new
        doc.expect :field_creator, field, []
        field.expect :value, 'Ted', []
        cite = Cite.new(doc: doc, mappings: mappings)
        cite.to_s.must_equal 'WOWO(Ted).'
        doc.verify
        field.verify
      end

      describe 'when a value is set' do
        it 'uses the value' do
          mappings = [{
            name: 'publisher',
            value: "UMN",
            prefix: '',
            suffix: '',
            formatters: []
          }]
          doc = {}
          cite = Cite.new(doc: doc, mappings: mappings)
          cite.to_s.must_equal 'UMN'
        end
      end
    end
  end
end
