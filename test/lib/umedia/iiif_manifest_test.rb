require 'test_helper'

module Umedia
  class IiifManifestTest < ActiveSupport::TestCase
    describe 'when an item is not a compound' do
      describe 'and it is not an image' do
        it 'does not have a manifest' do
          IiifManifest.new(viewer_type: 'foo').url.must_equal(false)
        end
      end
      describe 'and it is an image' do
        it 'has a manifest' do
          IiifManifest.new(viewer_type: 'image').url.must_equal("https://cdm16022.contentdm.oclc.org/iiif/info/MISSING_COLLECTION/MISSING_ITEM_ID/manifest.json")
        end
      end
    end

    describe 'when an item is a compound' do
      id = 154
      collection = 'foo123'
      search_config_klass = Minitest::Mock.new
      search_klass = Minitest::Mock.new
      search_klass_obj = Minitest::Mock.new
      item_klass  = Minitest::Mock.new

      describe 'and has no image children' do
        it 'has a no manifest' do
          search_config_klass.expect :new, {'foo' => 'bar'}, [{:page=>0, :rows=>100}]
          search_klass.expect :new, search_klass_obj, [{parent_id: "#{collection}:#{id}", search_config: {"foo"=>"bar"}}]
          search_klass_obj.expect :items, [item_klass], []
          item_klass.expect :viewer_type, 'foo', []
          IiifManifest.new(id: id,
                           collection: collection,
                           viewer_type: 'COMPOUND_PARENT_NO_VIEWER',
                           search_config_klass: search_config_klass,
                           child_search_klass: search_klass).url.must_equal(false)
        end
      end

      describe 'and has an image children' do
        it 'has a manifest' do
          search_config_klass.expect :new, {'foo' => 'bar'}, [{:page=>0, :rows=>100}]
          search_klass.expect :new, search_klass_obj, [{parent_id: "#{collection}:#{id}", search_config: {"foo"=>"bar"}}]
          search_klass_obj.expect :items, [item_klass], []
          item_klass.expect :viewer_type, 'image', []
          IiifManifest.new(id: id,
                           collection: collection,
                           viewer_type: 'COMPOUND_PARENT_NO_VIEWER',
                           search_config_klass: search_config_klass,
                           child_search_klass: search_klass).url.must_equal("https://cdm16022.contentdm.oclc.org/iiif/info/foo123/154/manifest.json")
        end
      end
    end
  end
end
