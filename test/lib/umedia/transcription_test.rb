require 'test_helper'

module Umedia
  class ItemTest < ActiveSupport::TestCase
    describe 'when an item is a compound' do
      it 'returns an array of transcript values' do
        item_klass = Minitest::Mock.new
        item_klass_obj = Minitest::Mock.new
        children_klass = Minitest::Mock.new
        children_klass_obj = Minitest::Mock.new
        children_klass_val_obj = Minitest::Mock.new

        id = 'foo'
        item_klass.expect :find, item_klass_obj, [id]
        item_klass_obj.expect :is_compound?, true, []
        children_klass.expect :find, [children_klass_obj], [id, {check_exists: false}]
        children_klass_obj.expect :field_transcription, children_klass_val_obj, []
        children_klass_val_obj.expect :value, 'foo', []
        transcript = Transcription.new(id: id, item_klass: item_klass, children_klass: children_klass)
        transcript.transcriptions.must_equal ['foo']
        item_klass.verify
        item_klass_obj.verify
        children_klass.verify
        children_klass_obj.verify
        children_klass_val_obj.verify
      end
    end

    describe 'when an item is not a compound' do
      it 'returns an array of transcript values' do
        id = 'foo'
        item_klass = Minitest::Mock.new
        item_klass_obj = Minitest::Mock.new
        item_klass_val_obj = Minitest::Mock.new
        item_klass.expect :find, item_klass_obj, [id]
        item_klass_obj.expect :is_compound?, false, []
        item_klass_obj.expect :field_transcription, item_klass_val_obj, []
        item_klass_val_obj.expect :value, 'bar', []
        transcript = Transcription.new(id: id, item_klass: item_klass)
        transcript.transcriptions.must_equal ['bar']
        item_klass.verify
        item_klass_obj.verify
        item_klass_val_obj.verify
      end
    end
  end
end
