module Umedia
  class Downloads
    attr_reader :viewer_type,
                :collection,
                :id,
                :parent_id,
                :parent_collection,
                :cdn_endpoint
    def initialize(viewer_type: 'image',
                   id: :MISSING_ID,
                   parent_id: :MISSING_PARENT_ID,
                   cdn_endpoint: 'http://cdm16022.contentdm.oclc.org')
      @viewer_type = viewer_type
      @collection  = id.split(':').first
      @id = id.split(':').last
      @parent_id = parent_id.split(':').last
      @parent_collection = parent_id.split(':').first
      @cdn_endpoint = cdn_endpoint
    end

    def downloads
      case viewer_type
      when /^kaltura/
        []
      when 'image'
        image_downloads
      when 'pdf'
        pdf_download
      end
    end

    def pdf_download
      "#{cdn_endpoint}/utils/getfile/collection/#{collection}/id/#{id}/filename"
    end

    def download_all_url
      "#{cdn_endpoint}/utils/getfile/collection/#{parent_collection}/id/#{parent_id}/filename/print/page/download/fparams/forcedownload"
    end

    def image_downloads
      [
        { url: "#{cdn_endpoint}/digital/iiif/#{collection}/#{id}/full/150,150/0/default.jpg", label: '(150 x 150 download)' },
        { url: "#{cdn_endpoint}/digital/iiif/#{collection}/#{id}/full/800,800/0/default.jpg", label: '(800 x 800 download)' },
        { url: "#{cdn_endpoint}/digital/iiif/#{collection}/#{id}/full/1920,1920/0/default.jpg", label: '(1920 x 1920 download)' }
      ]
    end
  end
end