module ItemsHelper
  def download_configs(docs)
    docs.map do |doc|
      download_config(doc)
    end
  end

  def download_config(doc)
    Umedia::Downloads.new(viewer_type: doc.field_viewer_type.value,
                          id: doc.id,
                          parent_id: doc.field_parent_id.value)
  end

  def single_item_download_config(doc)
    Umedia::Downloads.new(viewer_type: doc.field_viewer_type.value,
                          id: doc.id,
                          parent_id: doc.id)
  end
end
