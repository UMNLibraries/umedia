require 'test_helper'

module Umedia
  module Citation
    class FieldTest < ActiveSupport::TestCase
      it 'produces a string with a formatted value' do
        class FakeFormatter
          def self.format(value)
            "[#{value}]"
          end
        end

        field = Field.new(prefix: '--',
                          suffix: '++',
                          value: 'stuff',
                          formatters: [FakeFormatter]).to_s
        _(field).must_equal '--[stuff]++'
      end
    end
  end
end
