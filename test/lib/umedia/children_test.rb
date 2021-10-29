require 'test_helper'

module Umedia
  class ChildrenTest < ActiveSupport::TestCase
    describe 'when we are nut just checking to see if children exist for this item' do
      it 'searches for and caches item children and returns up to 10000 rows (really, not ever more than 2k)' do
        id = 'foo124'
        search_klass = mock()
        search_klass_obj = mock()
        search_config_klass = mock()
        search_config_klass_obj = mock()
        search_config_klass.expects(:new).with({:fl=>"*", :rows=>10000, :fq=>[]}).returns(search_config_klass_obj)
        search_klass.expects(:new).with({parent_id: id, search_config: search_config_klass_obj}).returns(search_klass_obj)
        search_klass_obj.expects(:hash).returns('5bc275da8a33')
        search_klass_obj.expects(:hash).returns('5bc275da8a33')
        search_klass_obj.expects(:items).returns('blah')
        children = Children.new(parent_id: id, search_klass: search_klass, search_config_klass: search_config_klass)
        _(children.find).must_equal 'blah'
        _(children.cache_key).must_equal 'children/foo124/5bc275da8a33'
      end
    end

    describe 'when we are just checking to see if children exist for this item' do
      it 'searches for and caches item children and returns one row' do
        id = 'foo124'
        search_klass = mock()
        search_klass_obj = mock()
        search_config_klass = mock()
        search_config_klass_obj = mock()
        search_config_klass.expects(:new).with({:fl=>"*", :rows=>0, :fq=>[]}).returns(search_config_klass_obj)
        search_klass.expects(:new).with({parent_id: id, search_config: search_config_klass_obj}).returns(search_klass_obj)
        search_klass_obj.expects(:hash).returns('5bc275da8a33')
        search_klass_obj.expects(:hash).returns('5bc275da8a33')
        search_klass_obj.expects(:items).returns('blah')
        children = Children.new(check_exists: true, parent_id: id, search_klass: search_klass, search_config_klass: search_config_klass)
        _(children.find).must_equal 'blah'
        _(children.cache_key).must_equal 'children/foo124/5bc275da8a33'
      end
    end

    describe 'when a ChildSearch is empty' do
      it 'children are empty' do
        id = 'foo124'
        search_klass = mock()
        search_klass_obj = mock()
        search_config_klass = mock()
        search_config_klass_obj = mock()
        search_config_klass.expects(:new).with({:fl=>"*", :rows=>0, :fq=>[]}).returns(search_config_klass_obj)
        search_klass.expects(:new).with({parent_id: id, search_config: search_config_klass_obj}).returns(search_klass_obj)
        search_klass_obj.expects(:num_found).returns(0)
        children = Children.new(check_exists: true, parent_id: id, search_klass: search_klass, search_config_klass: search_config_klass)
        _(children.num_found).must_equal 0
      end
    end
  end
end
