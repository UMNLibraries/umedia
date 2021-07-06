require 'test_helper'

module Umedia
  module EtlFormatters

    class AttachmentTest < ActiveSupport::TestCase
      describe 'when an item is a kaltura item' do
        it 'correctly codes its attachments' do
          %w[kaltur kaltua kaltub kaltuc kaltud].map do |kaltura|
            _(Attachment.new(record: { 'find' => 'foo.pdf', kaltura => 'blah' }).format
	     ).must_equal('pdf')
            _(Attachment.new(record: { 'find' => 'foo.jp2', kaltura => 'blah' }).format
	     ).must_equal('iiif')
            _(Attachment.new(record: { 'find' => 'foo.nope', kaltura => 'blah' }).format
	     ).must_be_nil
          end
        end
      end

      describe 'when an item is a parent coded with a child attachment' do
        it 'correctly codes its attachments' do
          parent = {'parent' => {'attach' => 'coll123:999' } }
          record = { 'record_type' => 'secondary', 'id' => 'coll123:999'}.merge(parent)
          _(Attachment.new(record: record.merge('find' => 'foo.pdf')).format).must_equal('pdf')
          _(Attachment.new(record: record.merge('find' => 'foo.jp2')).format).must_equal('iiif')
          _(Attachment.new(record: record.merge('find' => 'foo.nope')).format).must_be_nil
        end
      end

      describe 'when an item is niether a kaltura item or coded with a child attachment' do
        it 'is not attachable' do
          _(Attachment.new(record: { 'find' => 'foo.pdf', 'kaltur' => {}}).format
	   ).must_be_nil
          _(Attachment.new(record: { 'find' => 'foo.jp2', 'kaltur' => {}}).format
	   ).must_be_nil
          _(Attachment.new(record: { 'find' => 'foo.nope', 'kaltur' => {} }).format
	   ).must_be_nil
        end
      end
    end

  end
end
