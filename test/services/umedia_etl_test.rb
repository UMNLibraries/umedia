require 'test_helper'

  class UmediaETLTest < ActiveSupport::TestCase
    describe 'when using the default settings' do
      it 'returns some Umedia set_specs and a config' do
        umedia_etl = UmediaETL.new(field_mappings: {})
        _(umedia_etl.set_specs.length.positive?).must_equal true
        _(umedia_etl.config).must_equal(
          :oai_endpoint=>"http://cdm16022.contentdm.oclc.org/oai/oai.php",
          :extract_compounds=>true,
          :field_mappings=>{},
          :cdm_endpoint=>"https://server16022.contentdm.oclc.org/dmwebservices/index.php",
          :max_compounds=>1,
          :batch_size=>50,
          :solr_config=>{:url=>"http://solr_test:8983/solr/core"}
        )
      end

      it 'returns some Umedia set data' do
        umedia_etl = UmediaETL.new(field_mappings: {})
        _(umedia_etl.sets.length.positive?).must_equal true
      end
    end
  end
