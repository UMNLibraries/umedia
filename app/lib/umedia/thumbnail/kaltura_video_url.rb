# frozen_string_literal: true

module Umedia
  module Thumbnail
    class KalturaVideoUrl
      extend Forwardable
      def_delegators :@item, :field_viewer_type
      attr_reader :item
      def initialize(item: :MISSING_ITEM)
        @item = item
      end

      def to_s
        "https://cdnapisec.kaltura.com/p/1369852/thumbnail/entry_id/#{entry_id}"
      end

      def viewer_type
        item.field_viewer_type.value.to_s
      end

      def entry_id
        item.send(:"field_#{viewer_type}").value
      end
    end
  end
end
