module Parhelion
  module Viewers
    class OpenSeadragon
      extend Forwardable
      def_delegators :@item, :[], :id, :collection

      attr_reader :item, :uri
      def initialize(item: Parhelion::Item.new,
                     uri: 'https://cdm16022.contentdm.oclc.org')
        @item = item
        @uri = uri
      end

      def partial_name
        'openseadragon'
      end

      def config
        {
          currentRotation: 0,
          defaultZoomLevel: 0,
          tileSources: [src],
          sequenceMode: false,
          showReferenceStrip: false,
          showNavigator: true,
          id: 'osd-viewer',
          visibilityRatio: 1.0,
          constrainDuringPan: false,
          defaultZoomLevel: 0,
          minZoomLevel: 0,
          maxZoomLevel: 10,
          zoomInButton: 'zoom-in',
          zoomOutButton: 'zoom-out',
          rotateRightButton: 'rotate-right',
          rotateLeftButton: 'rotate-left',
          homeButton: 'reset',
          fullPageButton: 'full-page',
          previousButton: 'sidebar-previous',
          nextButton: 'sidebar-next'
        }
      end

      private

      def src
        "#{uri}/digital/iiif/#{collection}/#{id}/info.json"
      end
    end
  end
end
