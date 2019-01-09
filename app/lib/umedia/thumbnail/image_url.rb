# frozen_string_literal: true

module Umedia
  module Thumbnail
    class ImageUrl
      extend Forwardable
      def_delegators :@iiif_config, :info, :endpoint
      def_delegators :@item, :id, :collection, :field_object
      attr_reader :item, :iiif_thumb
      def initialize(item: :MISSING_ITEM,
                     iiif_thumb: false,
                     iiif_config_klass: Parhelion::IiifConfig)
        @item = item
        @iiif_thumb = iiif_thumb
        @iiif_config = iiif_config_klass.new(collection: collection, id: id)
      end

      def to_s
        iiif_thumb ? iiif_url : default_thumb_url
      end

      private

      def default_thumb_url
        field_object.value.to_s
      end

      def iiif_url
        [endpoint,
         'digital',
         'iiif',
         collection,
         id,
         'full',
         "#{width},",
         '0',
         'default.jpg'].join('/')
      end

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
