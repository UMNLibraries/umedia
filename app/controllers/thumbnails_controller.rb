class ThumbnailsController < ActionController::Base
  def update
    upload! if (!doc.nil?)
    render plain: "OK"
  end

  def upload!
    Thumbnailer.new(doc_hash: thumb_url.hash,
                    thumb_url: thumb_url.url).upload!
  end

  def thumb_url
    @thumb_url ||=
      Umedia::Thumbnail.new(object_url: doc.field_object.value,
                            viewer_type: doc.field_child_viewer_types.value.first,
                            entry_id: doc.field_kaltura_video.value)
  end

  def doc
    @doc ||= Umedia::ItemSearch.new(id: thumbnail_params[:item_id]).item
  end

  def thumbnail_params
    params.permit(:item_id)
  end
end