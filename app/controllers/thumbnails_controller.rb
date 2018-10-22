class ThumbnailsController < ActionController::Base
  def update
    upload! if (!item.nil?)
    render plain: "OK"
  end

  def upload!
    Thumbnailer.new(doc_hash: thumb_url.hash,
                    thumb_url: thumb_url.url).upload!
  end

  def thumb_url
    @thumb_url ||=
      Umedia::Thumbnail.new(object_url: item.field_object.value,
                            viewer_type: item.field_first_viewer_type.value,
                            entry_id: item.field_kaltura_video.value)
  end

  def item
    @item ||=
      Rails.cache.fetch("item/#{thumbnail_params[:item_id]}") do
        Umedia::ItemSearch.new(id: thumbnail_params[:item_id]).item
      end
  end

  def thumbnail_params
    params.permit(:item_id)
  end
end