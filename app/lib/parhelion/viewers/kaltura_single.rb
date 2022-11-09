module Parhelion
  module Viewers
    class KalturaSingle < Kaltura

      def flashvars
        {
          streamerType: 'auto'
        }
      end

      def uiconf_id
        50307192
      end
    end
  end
end
