require 'test_helper'

module Umedia
  class RecordCountTest < ActiveSupport::TestCase
    describe 'when not requesting children' do
      it 'provides a count of all primary records' do
        response = { 'response' => { 'numFound' => 99 }}
        solr = Minitest::Mock.new
        solr.expect :get, response, ["select", {:params=>{:q=>"document_type:item && record_type:\"primary\"", :rows=>0}}]
        search = RecordCountSearch.new(solr: solr)
        search.count.must_equal 99
        solr.verify
      end
    end
    describe 'when requesting children' do
      it 'provides a count of all records, including children' do
        response = { 'response' => { 'numFound' => 99 }}
        solr = Minitest::Mock.new
        solr.expect :get, response, ["select", {:params=>{:q=>"!viewer_type:COMPOUND_PARENT_NO_VIEWER && document_type:item", :rows=>0}}]
        search = RecordCountSearch.new(solr: solr, include_children: true)
        search.count.must_equal 99
        solr.verify
      end
    end
  end
end
