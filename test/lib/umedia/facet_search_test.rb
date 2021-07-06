require 'test_helper'

module Umedia
  class FacetSearchTest < ActiveSupport::TestCase
    describe 'when a facet search result returns no results on the second page' do
      it 'knows that there is neither  a previous or next page' do
        search_klass = Minitest::Mock.new
        search = Minitest::Mock.new
        search_klass.expect :new, search, [{:q=>"", :fl=>"id", :facet_config=>{"facet.field"=>:MISSING_FACET_FIELDS, "facet.limit"=>15, "facet.prefix"=>"", "facet.sort"=>"count", "facet.offset"=>0, :fq=>["record_type:primary"]}}]
        search_klass.expect :new, search, [{:q=>"", :fl=>"id", :facet_config=>{"facet.field"=>:MISSING_FACET_FIELDS, "facet.limit"=>15, "facet.prefix"=>"", "facet.sort"=>"count", "facet.offset"=>15, :fq=>["record_type:primary"]}}]
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
        _(fs.results).must_equal({"subject_ss"=>["foo", "bar"]})
        _(fs.next_page).must_equal 0
        _(fs.prev_page).must_equal 0
        _(fs.next_class).must_equal 'disabled'
        _(fs.prev_class).must_equal 'disabled'
        search_klass.verify
      end
    end

    describe 'when a facet search result returns results on the second page' do
      it 'knows that there is no previous page but that there is a next page' do
        search_klass = Minitest::Mock.new
        search = Minitest::Mock.new
        search_klass.expect :new, search, [{:q=>"", :fl=>"id", :facet_config=>{"facet.field"=>:MISSING_FACET_FIELDS, "facet.limit"=>15, "facet.prefix"=>"", "facet.sort"=>"count", "facet.offset"=>0, :fq=>["record_type:primary"]}}]
        search_klass.expect :new, search, [{:q=>"", :fl=>"id", :facet_config=>{"facet.field"=>:MISSING_FACET_FIELDS, "facet.limit"=>15, "facet.prefix"=>"", "facet.sort"=>"count", "facet.offset"=>15, :fq=>["record_type:primary"]}}]
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
        _(fs.results).must_equal({"subject_ss"=>["foo", "bar"]})
        _(fs.next_page).must_equal 1
        _(fs.prev_page).must_equal 0
        _(fs.next_class).must_equal ''
        _(fs.prev_class).must_equal 'disabled'
        search_klass.verify
      end
    end
  end
end
