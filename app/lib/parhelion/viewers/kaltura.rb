module Parhelion
  module Viewers
    class Kaltura
      extend Forwardable
      def_delegators :@item, :[], :id, :collection
      attr_reader :item, :entry_id, :uri
      def initialize(entry_id: '',
                     item: Parhelion::Item.new,
                     uri: 'https://cdm16022.contentdm.oclc.org')
        @entry_id = entry_id
        @item = item
        @uri = uri
      end

      def partial_name
        if item.field_kaltura_video_playlist.value
          'kaltura_compound'
        elsif item.field_kaltura_video.value
          'kaltura_video'
        elsif item.field_kaltura_audio_playlist.value
          'kaltura_compound'
        elsif item.field_kaltura_audio.value
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

      def src
        "#{uri}/utils/getstream/collection/#{collection}/id/#{id}"
      end
    end
  end
end
