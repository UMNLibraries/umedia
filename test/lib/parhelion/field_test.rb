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

  describe 'when a field is queried for locale prefix' do
    it 'sets the correct locale'
      _(Field.new(name: 'es_thing', value: 'value').locale).must_equal :es
    end

    it 'defaults to the I18n default locale'
      _(Field.new(name: 'thing', value: 'value').locale).must_equal :en
    end
  end
end
