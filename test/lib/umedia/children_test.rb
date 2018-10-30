require 'test_helper'

module Umedia
  class ItemTest < ActiveSupport::TestCase
    describe 'when we are nut just checking to see if children exist for this item' do
      it 'searches for and caches item children and returns up to 10000 rows (really, not ever more than 2k)' do
        id = 'foo124'
        search_klass = Minitest::Mock.new
        search_klass_obj = Minitest::Mock.new
        search_klass.expect :new, search_klass_obj, [{:parent_id=>"foo124", :fl=>"*", :rows=>10000, :fq=>[]}]
        search_klass_obj.expect :items, nil, []
        Children.find(id, search_klass: search_klass)
        search_klass.verify
        search_klass_obj.verify
      end
    end

    describe 'when we are just checking to see if children exist for this item' do
      it 'searches for and caches item children and returns one row' do
        id = 'foo124'
        search_klass = Minitest::Mock.new
        search_klass_obj = Minitest::Mock.new
        search_klass.expect :new, search_klass_obj, [{:parent_id=>"foo124", :fl=>"*", :rows=>1, :fq=>[]}]
        search_klass_obj.expect :items, nil, []
        Children.find(id, search_klass: search_klass, check_exists: true)
        search_klass.verify
        search_klass_obj.verify
      end
    end
  end
end
