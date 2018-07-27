require "rest-client"

module Umedia
  class Downloads
    attr_reader :viewer_type,
                :collection,
                :id,
                :parent_id,
                :parent_collection,
                :cdn_endpoint,
                :rest_client_klass
    def initialize(viewer_type: 'image',
                   id: :MISSING_ID,
                   parent_id: :MISSING_PARENT_ID,
                   cdn_endpoint: 'http://cdm16022.contentdm.oclc.org',
                   rest_client_klass: RestClient)
      @viewer_type = viewer_type
      @collection  = id.split(':').first
      @id = id.split(':').last
      @parent_id = parent_id.split(':').last
      @cdn_endpoint = cdn_endpoint
      @rest_client_klass = rest_client_klass
    end

    def is_child?
      id != parent_id
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
      "#{cdn_endpoint}/utils/getfile/collection/#{collection}/id/#{parent_id}/filename/print/page/download/fparams/forcedownload"
    end

    def info
      @info ||= JSON.parse(rest_client_klass.get(info_url).body)
    end

    def info_url
      "#{cdn_endpoint}/digital/iiif/#{collection}/#{parent_id}/info.json"
    end

    def image_downloads
      desired_sizes.map do |size|
        if info['height'] >= size && info['width'] >= size
          image_download("#{size},#{size}", "#{size} x #{size}")
        end
      end.compact << image_download('full', 'Full')
    end

    def desired_sizes
      [150, 800, 1920]
    end

    def image_download(size, label)
      { url: "#{cdn_endpoint}/digital/iiif/#{collection}/#{id}/full/#{size}/0/default.jpg", label: "(#{label} Download)" }
    end
  end
end