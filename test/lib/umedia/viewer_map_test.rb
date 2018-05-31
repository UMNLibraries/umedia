require 'test_helper'

module Umedia
  class ViewerMapTest < ActiveSupport::TestCase
    describe 'when a kaltura field is present' do
      describe 'and when no format ("find") field data is present' do
        it 'returns the kaltura field' do
          record = { 'kalturd' => 'blah:123', 'find' => 'blah.jp2' }
          ViewerMap.new(record: record).viewer.must_equal 'kaltura_combo_playlist'
        end
      end
      describe 'and no format("find") field is present' do
        it 'returns the kaltura field' do
          record = { 'kalturd' => 'blah:123'}
          ViewerMap.new(record: record).viewer.must_equal 'kaltura_combo_playlist'
        end
      end
    end
    describe 'when a kaltura field is not present' do
      describe 'and a known format/find field is present' do
        it 'delivers the correct viewer' do
          record = { 'find' => 'foobar.pdf'}
          ViewerMap.new(record: record).viewer.must_equal 'pdf'
        end
      end
      describe 'and an unknown format/find field is present' do
        it 'raises an error' do
          record = { 'find' => 'foobar.zardoz'}
          err = ->{ ViewerMap.new(record: record).viewer }.must_raise RuntimeError
          err.message.must_equal 'Unknown viewer format: zardoz'
        end
      end
    end
    describe 'when a kaltura field is present but empty' do
      it 'uses the find field' do
        record = { 'find' => 'foobar.pdf', 'kalturd' => {}}
        ViewerMap.new(record: record).viewer.must_equal 'pdf'
      end
    end
  end
end
