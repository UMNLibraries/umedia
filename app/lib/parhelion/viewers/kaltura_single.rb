module Parhelion
  module Viewers
    class KalturaSingle < Kaltura

      def flashvars
        {
          streamerType: 'auto'
        }
      end

      def uiconf_id
        42156071
      end
    end
  end
end
