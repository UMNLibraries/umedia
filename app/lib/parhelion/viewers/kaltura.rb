module Parhelion
  module Viewers
    class Kaltura
      attr_reader :document, :entry_id, :uri
      def initialize(entry_id: '',
                     document: Parhelion::Document.new,
                     uri: 'https://cdm16022.contentdm.oclc.org')
        @entry_id = entry_id
        @document = document
        @uri = uri
      end

      def partial_name
        if document.field_kaltura_video_playlist.value
          'kaltura_compound'
        elsif document.field_kaltura_video.value
          'kaltura_video'
        elsif document.field_kaltura_audio_playlist.value
          'kaltura_compound'
        elsif document.field_kaltura_audio.value
          'kaltura_audio'
        end
      end

      def config
        {
          targetId: target_id,
          wid: wid,
          uiconf_id: uiconf_id,
          entry_id: entry_id,
          flashvars: flashvars
        }
      end

      private

      # wid = kaltura partner ID
      def wid
        '_1369852'
      end

      def target_id
        'kaltura_player'
      end

      def id
        doc_ids.last
      end

      def collection
        doc_ids.first
      end

      def doc_ids
        document.id.split(':')
      end

      def src
        "#{uri}/utils/getstream/collection/#{collection}/id/#{id}"
      end
    end
  end
end
