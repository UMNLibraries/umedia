require 'test_helper'
module Parhelion
  class FieldTest < ActiveSupport::TestCase
    describe 'when a field value is empty' do
      it 'indicates the field is not for display' do
        _(Field.new(value: {}).display?).must_equal false
        _(Field.new(value: []).display?).must_equal false
        _(Field.new(value: '').display?).must_equal false
      end
    end

    it 'tells us that it exists' do
      _(Field.new(value: {}).exists?).must_equal true
    end
  end
end
