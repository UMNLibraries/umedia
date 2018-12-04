# frozen_string_literal: true

module Umedia
  module Thumbnail
    class KalturaVideoUrl
      attr_reader :entry_id
      def initialize(entry_id: :MISSING_ENTRY_ID)
        @entry_id = entry_id
      end

      def to_s
        "https://cdnapisec.kaltura.com/p/1369852/thumbnail/entry_id/#{entry_id}"
      end
    end
  end
end
