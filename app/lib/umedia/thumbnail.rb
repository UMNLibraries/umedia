# frozen_string_literal: true
require 'digest/sha1'

module Umedia
  class Thumbnail
    attr_reader :object_url, :viewer_type, :entry_id, :cdn_uri
    def initialize(object_url: :MISSING_OBJECT_URL,
                   viewer_type: :MISSING_VIEWER_TYPE,
                   entry_id: :MISSING_ENTRY_ID,
                   cdn_uri: ENV['UMEDIA_NAILER_CDN_URI'])
      @object_url = object_url
      @viewer_type = viewer_type
      @entry_id = entry_id
      @cdn_uri = cdn_uri
    end

    def url
      case viewer_type
      when 'kaltura_video'
        kaltura_thumb_url
      else
        object_url
      end
    end

    def default_url
      "#{cdn_uri}/default_thumbnail.gif"
    end

    def cdn_url
      if object_url
        "#{cdn_uri}/#{url_hash}.png"
      else
        default_url
      end
    end

    private

    def url_hash
      Digest::SHA1.hexdigest url
    end

    def kaltura_thumb_url
      "https://cdnapisec.kaltura.com/p/1369852/thumbnail/entry_id/#{entry_id}"
    end
  end
end