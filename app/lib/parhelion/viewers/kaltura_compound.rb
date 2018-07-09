module Parhelion
  module Viewers
    class KalturaCompound < Kaltura

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

      def flashvars
        {
          "streamerType": "auto",
          "playlistAPI.kpl0Id": entry_id
        }
      end

      def uiconf_id
        41902002
      end
    end
  end
end
