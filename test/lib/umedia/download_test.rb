require 'test_helper'

module Umedia
  class DownloadTest < ActiveSupport::TestCase
    describe 'when requesting downloads for an image viewer' do
      it 'produces the correct image urls' do
        item = Parhelion::Item.new(doc_hash: { 'id' => 'p16022coll142:147', 'viewer_type' => 'image'})
        download = Download.new(item: item)
        _(download.urls).must_equal([
          {:url=>"https://cdm16022.contentdm.oclc.org/digital/iiif/p16022coll142/147/full/150,/0/default.jpg", :label=>"Small image"},
          {:url=>"https://cdm16022.contentdm.oclc.org/utils/ajaxhelper?CISOROOT=p16022coll142&CISOPTR=147&action=2&DMSCALE=100&DMWIDTH=1187&DMHEIGHT=777", :label=>"Full-size image"}
        ])
      end
    end
    describe 'when requesting downloads for an kaltura viewer' do
      it 'produces an empty url config' do
        item = Parhelion::Item.new(doc_hash: { 'id' => 'p16022coll142:147', 'viewer_type' => 'kaltura_foo'})
        download = Download.new(item: item)
        _(download.urls).must_equal []
      end
    end
    describe 'when requesting downloads for an pdf viewer' do
      it 'produces an cdm file download' do
        item = Parhelion::Item.new(doc_hash: { 'id' => 'p16022coll142:147', 'viewer_type' => 'pdf'})
        download = Download.new(item: item)
        _(download.urls).must_equal 'https://cdm16022.contentdm.oclc.org/utils/getfile/collection/p16022coll142/id/147/filename'
      end
    end
  end
end
