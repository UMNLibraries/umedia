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

    it 'tells us that it exists' do
      Field.new(value: {}).exists?.must_equal true
      Field.new(value: {}).missing?.must_equal false
    end
  end
end
