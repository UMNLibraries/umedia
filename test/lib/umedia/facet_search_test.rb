require 'test_helper'

module Umedia
  class FacetSearchTest < ActiveSupport::TestCase
    describe 'when a facet search result returns no results on the second page' do
      it 'knows that there is neither  a previous or next page' do
        search_klass = Minitest::Mock.new
        search = Minitest::Mock.new
        search_klass.expect :new, search, [{:q=>"", :fl=>"id", :facet_config=>{"facet.field"=>[:MISSING_FACET_FIELD], "facet.limit"=>15, "facet.prefix"=>"", "facet.sort"=>"count", "facet.offset"=>0, :fq=>["record_type:primary"]}}]
        search_klass.expect :new, search, [{:q=>"", :fl=>"id", :facet_config=>{"facet.field"=>[:MISSING_FACET_FIELD], "facet.limit"=>15, "facet.prefix"=>"", "facet.sort"=>"count", "facet.offset"=>15, :fq=>["record_type:primary"]}}]
        search.expect :response, {
          'facet_counts' => {
            'facet_fields' => {
              'subject_ss' => ['foo', 'bar']
            }
          }
        },
        []
        search.expect :response, {
          'facet_counts' => {
            'facet_fields' => {
              'subject_ss' => []
            }
          }
        },
        []
        fs = FacetSearch.new(search_klass: search_klass)
        fs.results.must_equal({"subject_ss"=>["foo", "bar"]})
        fs.next_page.must_equal 0
        fs.prev_page.must_equal 0
        fs.next_class.must_equal 'disabled'
        fs.prev_class.must_equal 'disabled'
        search_klass.verify
      end
    end

    describe 'when a facet search result returns results on the second page' do
      it 'knows that there is no previous page but that there is a next page' do
        search_klass = Minitest::Mock.new
        search = Minitest::Mock.new
        search_klass.expect :new, search, [{:q=>"", :fl=>"id", :facet_config=>{"facet.field"=>[:MISSING_FACET_FIELD], "facet.limit"=>15, "facet.prefix"=>"", "facet.sort"=>"count", "facet.offset"=>0, :fq=>["record_type:primary"]}}]
        search_klass.expect :new, search, [{:q=>"", :fl=>"id", :facet_config=>{"facet.field"=>[:MISSING_FACET_FIELD], "facet.limit"=>15, "facet.prefix"=>"", "facet.sort"=>"count", "facet.offset"=>15, :fq=>["record_type:primary"]}}]
        search.expect :response, {
          'facet_counts' => {
            'facet_fields' => {
              'subject_ss' => ['foo', 'bar']
            }
          }
        },
        []
        search.expect :response, {
          'facet_counts' => {
            'facet_fields' => {
              'subject_ss' => ['baz']
            }
          }
        },
        []
        fs = FacetSearch.new(search_klass: search_klass)
        fs.results.must_equal({"subject_ss"=>["foo", "bar"]})
        fs.next_page.must_equal 1
        fs.prev_page.must_equal 0
        fs.next_class.must_equal ''
        fs.prev_class.must_equal 'disabled'
        search_klass.verify
      end
    end
  end
end
