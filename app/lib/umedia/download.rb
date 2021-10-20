# frozen_string_literal: true

module Umedia
  # Provide access to item download urls
  class Download
    extend Forwardable
    def_delegators :@item, :[], :id, :parent_id, :collection, :height, :width

    attr_reader :item,
                :cdn_endpoint

    def initialize(item: :MISSING_ID,
                   cdn_endpoint: 'https://cdm16022.contentdm.oclc.org')
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
      desired_sizes.map do |label, size|
        if size.eql? 'full'
          image_download(size, label)
        elsif height >= size && width >= size
          image_download("#{size},", label)
        end
      end.compact
    end

    def desired_sizes
      {'Small': 150, 'Medium': 800, 'Large': 1920, 'Full-size': 'full'}
    end

    def image_download(size, label)
      {url: "#{cdn_endpoint}/digital/iiif/#{collection}/#{id}/full/#{size}/0/default.jpg", label: "#{label} image"}
    end
  end
end
