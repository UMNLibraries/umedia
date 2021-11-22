# frozen_string_literal: true

module Umedia
  # Provide access to item download urls
  class Download
    extend Forwardable
    def_delegators :@item, :[], :id, :parent_id, :collection, :height, :width, :original_height, :original_width

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

    def download_full_image_url
      "#{cdn_endpoint}/utils/ajaxhelper?CISOROOT=#{collection}&CISOPTR=#{id}&action=2&DMSCALE=100&DMWIDTH=#{item.original_width}&DMHEIGHT=#{item.original_height}"
    end

    private

    def image_downloads
      desired_sizes.map do |label, size|
        if size.eql? 'full'
          image_download(size, label)
        elsif height >= size && width >= size
          # We specify only the width here, because specifying width x height,
          # as we did previsouly with identical values, will force all images
          # to have square aspect ratios, which distorts most of them.
          image_download("#{size},", label)
        end
      end.compact
    end

    def desired_sizes
      {'Small': 150, 'Medium': 800, 'Large': 1920, 'Full-size': 'full'}
    end

    def image_download(size, label)
      url = case size
        when 'full'
          download_full_image_url
        else
          "#{item.iiif_url}/full/#{size}/0/default.jpg"
        end
        {url: url, label: "#{label} image"}
    end
  end
end
