# frozen_string_literal: true

module Umedia
  module Thumbnail
    class ImageUrl
      extend Forwardable
      def_delegators :@iiif_config, :info, :endpoint
      attr_reader :collection, :id
      def initialize(collection: :MISSING_COLLECTION,
                     id: :MISSING_ID,
                     iiif_config_klass: Parhelion::IiifConfig)
        @collection = collection
        @id = id
        @iiif_config = iiif_config_klass.new(collection: collection, id: id)
      end

      def to_s
        "#{endpoint}/digital/iiif/#{collection}/#{id}/full/#{width},/0/default.jpg"
      end

      private

      def width
        best_size ? best_size['width'] : sizes.last['width']
      end

      def best_size
        sizes.select do |size|
          size['width'] >= 300
        end.last
      end

      def sizes
        @sizes ||= info['sizes']
      end
    end
  end
end
