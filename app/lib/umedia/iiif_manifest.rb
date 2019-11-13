module Umedia
  class IiifManifest
    attr_reader :id, :collection, :viewer_type, :child_search_klass, :search_config_klass
    def initialize(id: :MISSING_ITEM_ID,
                   collection: :MISSING_COLLECTION,
                   viewer_type: :MISSING_VIEWER_TYPE,
                   child_search_klass: Umedia::ChildSearch,
                  search_config_klass: Parhelion::SearchConfig)
      @id = id
      @collection = collection
      @viewer_type = viewer_type
      @child_search_klass = child_search_klass
      @search_config_klass = search_config_klass
    end

    def url
      @url ||= if exists?
        iiif_config.new(id: id,
                        collection: collection).manifest_url
      else
        false
      end
    end

    private

    def exists?
      case viewer_type
      when 'image'
        true
      when 'COMPOUND_PARENT_NO_VIEWER'
        child_viewer_types.include? 'image'
      else
        false
      end
    end

    def search_config
      search_config_klass.new(
        page: 0,
        rows: 100
      )
    end

    def children
      child_search_klass.new(parent_id: "#{collection}:#{id}",
                             search_config: search_config).items
    end

    def child_viewer_types
      children.map(&:viewer_type).uniq
    end

    def iiif_config
      Parhelion::IiifConfig
    end
  end
end
