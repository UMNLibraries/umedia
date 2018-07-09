# frozen_string_literal: true

module Parhelion
  module Viewers
    # Convert a Parhelion document into a viewer
    class Map
      attr_reader :document
      def initialize(document: Document.new)
        @document = document
      end

      def to_viewer
        mappings.fetch(document.field_viewer_types.value.first)
      end

      private

      def mappings
        {
          'image' => OpenSeadragon.new(document: document),
          'pdf' => PDF.new(document: document),
          'kaltura_audio' =>
            kaltura_single(document.field_kaltura_audio.value),
          'kaltura_audio_playlist' =>
            kaltura_compound(document.field_kaltura_audio_playlist.value),
          'kaltura_video' =>
            kaltura_single(document.field_kaltura_video.value),
          'kaltura_video_playlist' =>
            kaltura_compound(document.field_kaltura_video_playlist.value),
          'kaltura_combo_playlist' =>
            kaltura_compound(document.field_kaltura_combo_playlist.value)
        }
      end

      def kaltura_single(entry_id)
        KalturaSingle.new(entry_id: entry_id, document: document)
      end

      def kaltura_compound(entry_id)
        KalturaCompound.new(entry_id: entry_id, document: document)
      end
    end
  end
end