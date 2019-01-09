# frozen_string_literal: true
require 'digest/sha1'

module Umedia
  module Thumbnail
    # A wrapper around the multiple ways we generate thumb urls
    class Url
      attr_reader :item,
                  :iiif_thumb,
                  :image_url_klass,
                  :kaltura_audio_url_klass,
                  :kaltura_video_url_klass,
                  :pdf_url_klass,
                  :cdn_uri
      def initialize(item: Parhelion::Item.new,
                     iiif_thumb: false,
                     image_url_klass: ImageUrl,
                     kaltura_audio_url_klass: KalturaAudioUrl,
                     kaltura_video_url_klass: KalturaVideoUrl,
                     pdf_url_klass: PdfUrl,
                     cdn_uri: ENV['UMEDIA_NAILER_CDN_URI'])
        @item = item
        @iiif_thumb = iiif_thumb
        @image_url_klass = image_url_klass
        @kaltura_audio_url_klass = kaltura_audio_url_klass
        @kaltura_video_url_klass = kaltura_video_url_klass
        @pdf_url_klass = pdf_url_klass
        @cdn_uri = cdn_uri
      end

      def to_h
        {
          url: to_s,
          cdn: to_cdn_s
        }
      end

      def to_cdn_s
        "#{cdn_uri}/#{url_hash}.png"
      end

      def to_s
        @to_s ||=
          case viewer_type
          when 'image'
            image_url_klass.new(item: item, iiif_thumb: iiif_thumb)
          # Kaltura Audio Playlist
          when 'kaltura_audio_playlist'
            kaltura_audio_url_klass.new
          # Kaltura Audio
          when 'kaltura_audio'
            kaltura_audio_url_klass.new
          # Kaltura Combo Player (audio and video)
          when 'kaltura_combo_playlist'
            kaltura_video_url_klass.new(item: item)
          # Kaltura Video Playlist
          when 'kaltura_video_playlist'
            kaltura_video_url_klass.new(item: item)
          # Kaltura Video
          when 'kaltura_video'
            kaltura_video_url_klass.new(item: item)
          when 'pdf'
            pdf_url_klass.new
          else
            "No Thumbnail URL configured for type #{viewer_type}"
          end.to_s
      end

      private

      def url_hash
        Digest::SHA1.hexdigest to_s
      end

      def viewer_type
        item.field_viewer_type.value
      end
    end
  end
end