require 'test_helper'

module Parhelion
  class CdmIiifTest < ActiveSupport::TestCase
    it 'retrieves contentdm IIIF info' do
      iiif = IiifConfig.new(collection: 'p16022coll142', id: '147')
      VCR.use_cassette("iif_p16022coll142_147") do
        _(iiif.info).must_equal({"@context"=>"http://iiif.io/api/image/2/context.json", "@id"=>"https://cdm16022.contentdm.oclc.org/digital/iiif/p16022coll142/147", "height"=>777, "width"=>1187, "profile"=>["http://iiif.io/api/image/2/level1.json"], "protocol"=>"http://iiif.io/api/image", "tiles"=>[{"scaleFactors"=>[1, 2, 4, 8, 16], "width"=>1024}], "sizes"=>[{"width"=>1187, "height"=>777}, {"width"=>594, "height"=>389}, {"width"=>297, "height"=>194}, {"width"=>148, "height"=>97}, {"width"=>74, "height"=>49}]})
      end

      _(iiif.manifest_url).must_equal 'https://cdm16022.contentdm.oclc.org/iiif/info/p16022coll142/147/manifest.json'
    end
  end
end
