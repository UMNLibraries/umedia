# frozen_string_literal: true

module Umedia
  class FeaturedCollectionThumbnail
    attr_reader :id, :collection, :object_url, :viewer_type, :entry_id
    def initialize(id: :MISSING_ID,
                   collection: :MISSING_COLLECTION,
                   object_url: :MISSING_OBJECT_URL,
                   viewer_type: :MISSING_VIEWER_TYPE,
                   entry_id: :MISSING_ENTRY_ID)
      @id = id
      @collection = collection
      @object_url = object_url
      @viewer_type = viewer_type
      @entry_id = entry_id
    end

  end
end