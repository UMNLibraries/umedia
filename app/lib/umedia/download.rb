# frozen_string_literal: true

module Umedia
  # Provide access to item download urls
  class Download
    extend Forwardable
    def_delegators :@item, :[], :id, :parent_id, :collection, :height, :width

    attr_reader :item,
                :cdn_endpoint

    def initialize(item: :MISSING_ID,
                   cdn_endpoint: 'http://cdm16022.contentdm.oclc.org')
      @item = item
      @cdn_endpoint = cdn_endpoint
    end

    def is_child?
      id != parent_id
    end

    def urls
      case item.field_viewer_type.value
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

    private

    def image_downloads
      desired_sizes.map do |size|
        if height >= size && width >= size
          image_download("#{size},#{size}", "#{size} x #{size}")
        end
      end.compact
    end

    def desired_sizes
      [150, 800, 1920]
    end

    def image_download(size, label)
      { url: "#{cdn_endpoint}/digital/iiif/#{collection}/#{id}/full/#{size}/0/default.jpg", label: "(#{label} Download)" }
    end
  end
end