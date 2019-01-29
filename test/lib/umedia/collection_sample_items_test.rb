require 'test_helper'

module Umedia
  class CollectionSampleItemsTest < ActiveSupport::TestCase
    it 'retrieves a set of sample items and a total primary page count for a collection' do
      response = {
        'response' => {
          'docs' => ['123'],
          'numFound' => 1
        }
      }
      solr = Minitest::Mock.new
      solr.expect :get, response, ["select", {:params=>{:rows=>3, :fl=>"*", :sort=>"featured_collection_order ASC", :q=>"set_spec:foobarbaz123 && document_type:item"}}]
      search = CollectionSampleItems.new(set_spec: "foobarbaz123", solr: solr)
      search.iiifables.first.doc_hash.must_equal "123"
      solr.verify
    end

    it 'retrieves sample items' do
      sample = CollectionSampleItems.new(set_spec: "p16022coll128")
      sample.iiifables.map {|item| item.doc_hash }.must_equal [{"id"=>"p16022coll128:8755", "object"=>"https://cdm16022.contentdm.oclc.org/utils/getthumbnail/collection/p16022coll128/id/8755", "set_spec"=>"p16022coll128", "collection_name"=>"Forecast Public Art Collection", "collection_name_s"=>"Forecast Public Art Collection", "collection_description"=>"This archival collection contains the records from Forecast Public Art, a St. Paul-based nonprofit arts organization dedicated to the study of and support for public art.", "title"=>"Page 1", "title_s"=>"Page 1", "title_t"=>"Page 1", "title_alternative"=>"Page 1", "title_alternative_s"=>"Page 1", "title_alternative_t"=>"Page 1", "dls_identifier"=>["umn159476"], "transcription"=>"OJl   111 ttf'?6*2-", "page_count"=>0, "record_type"=>"secondary", "parent_id"=>"p16022coll128:8823", "first_viewer_type"=>"image", "viewer_type"=>"image", "child_index"=>0, "attachment"=>"8756.jp2", "document_type"=>"item", "_version_"=>1618864276460535808}, {"id"=>"p16022coll128:8755", "object"=>"https://cdm16022.contentdm.oclc.org/utils/getthumbnail/collection/p16022coll128/id/8755", "set_spec"=>"p16022coll128", "collection_name"=>"Forecast Public Art Collection", "collection_name_s"=>"Forecast Public Art Collection", "collection_description"=>"This archival collection contains the records from Forecast Public Art, a St. Paul-based nonprofit arts organization dedicated to the study of and support for public art.", "title"=>"Page 1", "title_s"=>"Page 1", "title_t"=>"Page 1", "title_alternative"=>"Page 1", "title_alternative_s"=>"Page 1", "title_alternative_t"=>"Page 1", "dls_identifier"=>["umn159476"], "transcription"=>"OJl   111 ttf'?6*2-", "page_count"=>0, "record_type"=>"secondary", "parent_id"=>"p16022coll128:8823", "first_viewer_type"=>"image", "viewer_type"=>"image", "child_index"=>0, "attachment"=>"8756.jp2", "document_type"=>"item", "_version_"=>1618864276460535808}, {"id"=>"p16022coll128:8756", "object"=>"https://cdm16022.contentdm.oclc.org/utils/getthumbnail/collection/p16022coll128/id/8756", "set_spec"=>"p16022coll128", "collection_name"=>"Forecast Public Art Collection", "collection_name_s"=>"Forecast Public Art Collection", "collection_description"=>"This archival collection contains the records from Forecast Public Art, a St. Paul-based nonprofit arts organization dedicated to the study of and support for public art.", "title"=>"Page 2", "title_s"=>"Page 2", "title_t"=>"Page 2", "title_alternative"=>"Page 2", "title_alternative_s"=>"Page 2", "title_alternative_t"=>"Page 2", "dls_identifier"=>["umn159477"], "page_count"=>0, "record_type"=>"secondary", "parent_id"=>"p16022coll128:8823", "first_viewer_type"=>"image", "viewer_type"=>"image", "child_index"=>1, "attachment"=>"8757.jp2", "document_type"=>"item", "_version_"=>1618864276460535809}]
      sample.contributing_organization_name.must_equal 'University of Minnesota Libraries, Northwest Architectural Archives.'
    end
  end
end
