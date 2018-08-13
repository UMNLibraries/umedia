require 'test_helper'
module Parhelion
  class FacetQueryTest < ActiveSupport::TestCase
    describe 'when a pager param is present' do
      let(:params) { {'q' => 'finance', 'page' => '1'} }
      let(:query) { Query.new(params: params) }
      it 'removes the page param' do
        facet = FacetQuery.new(field: 'publisher',
                               value: 'bar',
                               query: query)

        facet.link_params.must_equal({"q"=>"finance", "facets"=>{"publisher"=>["bar"]}})
      end
    end
    describe 'when a facet is not active' do
      let(:params) { {'q' => 'finance'} }
      let(:query) { Query.new(params: params) }
      it 'creates a link query with its value' do
        facet = FacetQuery.new(field: 'publisher',
                               value: 'bar',
                               query: query)

        facet.link_params.must_equal({"q"=>"finance", "facets"=>{"publisher"=>["bar"]}})
      end
    end
    describe 'when a facet param is active' do
      let(:params) { {'q' => 'finance', 'facets' => {'publisher' => 'bar', 'year' => '1998'}} }
      let(:query) { Query.new(params: params) }
      it 'creates a link query without the facet value' do
        facet = FacetQuery.new(field: 'publisher',
                          value: 'bar',
                          query: query)
        facet.link_params.must_equal({"q"=>"finance", "facets"=>{"year"=>"1998"}})
      end
    end
    describe 'when a facet param is the last active facet' do
      let(:params) { {'q' => 'finance', 'facets' => {'publisher' => ['bar']}} }
      let(:query) { Query.new(params: params) }
      it 'removes the facet params altogether' do
        facet = FacetQuery.new(field: 'publisher',
                          value: 'bar',
                          query: query)
        facet.link_params.must_equal({"q"=>"finance"})
      end
    end

    describe 'when multiple values of a single facet are selected' do
      let(:params) { {'q' => 'finance', 'facets' => {'subject' => ['Minnesota', 'Duluth'], 'year' => '1998'}} }
      let(:query) { Query.new(params: params) }
      it 'creates a link query  without the facet value' do
        facet = FacetQuery.new(field: 'subject',
                          value: 'Duluth',
                          query: query)
        facet.link_params.must_equal({"q"=>"finance", "facets"=>{"subject"=>["Minnesota"], "year"=>"1998"}})
      end
    end
  end
end