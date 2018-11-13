require 'test_helper'

module Umedia
  class ChildrenTest < ActiveSupport::TestCase
    describe 'when we are nut just checking to see if children exist for this item' do
      it 'searches for and caches item children and returns up to 10000 rows (really, not ever more than 2k)' do
        id = 'foo124'
        search_klass = Minitest::Mock.new
        search_klass_obj = Minitest::Mock.new
        search_config_klass = Minitest::Mock.new
        search_config_klass_obj = Minitest::Mock.new
        search_config_klass.expect :new, search_config_klass_obj, [{:fl=>"*", :rows=>10000, :fq=>[]}]
        search_klass.expect :new, search_klass_obj, [{parent_id: id, search_config: search_config_klass_obj}]
        search_klass_obj.expect :hash, '5bc275da8a33', []
        search_klass_obj.expect :hash, '5bc275da8a33', []
        search_klass_obj.expect :items, 'blah', []
        children = Children.new(parent_id: id, search_klass: search_klass, search_config_klass: search_config_klass)
        children.find.must_equal 'blah'
        children.cache_key.must_equal 'children/foo124/5bc275da8a33'
        search_klass.verify
        search_klass_obj.verify
        search_config_klass.verify
        search_config_klass_obj.verify
      end
    end

    describe 'when we are just checking to see if children exist for this item' do
      it 'searches for and caches item children and returns one row' do
        id = 'foo124'
        search_klass = Minitest::Mock.new
        search_klass_obj = Minitest::Mock.new
        search_config_klass = Minitest::Mock.new
        search_config_klass_obj = Minitest::Mock.new
        search_config_klass.expect :new, search_config_klass_obj, [{:fl=>"*", :rows=>0, :fq=>[]}]
        search_klass.expect :new, search_klass_obj, [{parent_id: id, search_config: search_config_klass_obj}]
        search_klass_obj.expect :hash, '5bc275da8a33', []
        search_klass_obj.expect :hash, '5bc275da8a33', []
        search_klass_obj.expect :items, 'blah', []
        children = Children.new(check_exists: true, parent_id: id, search_klass: search_klass, search_config_klass: search_config_klass)
        children.find.must_equal 'blah'
        children.cache_key.must_equal 'children/foo124/5bc275da8a33'
        search_klass.verify
        search_klass_obj.verify
        search_config_klass.verify
        search_config_klass_obj.verify
      end
    end

    describe 'when a ChildSearch is empty' do
      it 'children are empty' do
        id = 'foo124'
        search_klass = Minitest::Mock.new
        search_klass_obj = Minitest::Mock.new
        search_config_klass = Minitest::Mock.new
        search_config_klass_obj = Minitest::Mock.new
        search_config_klass.expect :new, search_config_klass_obj, [{:fl=>"*", :rows=>0, :fq=>[]}]
        search_klass.expect :new, search_klass_obj, [{parent_id: id, search_config: search_config_klass_obj}]
        search_klass_obj.expect :num_found, 0, []
        children = Children.new(check_exists: true, parent_id: id, search_klass: search_klass, search_config_klass: search_config_klass)
        children.num_found.must_equal 0
        search_klass.verify
        search_klass_obj.verify
      end
    end
  end
end
