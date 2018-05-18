require 'test_helper'
module Parhelion
  class FieldTest < ActiveSupport::TestCase
    describe 'when a field value is empty' do
      it 'indicates the field is not for display' do
        Field.new(value: {}).display?.must_equal false
        Field.new(value: []).display?.must_equal false
        Field.new(value: '').display?.must_equal false
      end
    end
  end
end
