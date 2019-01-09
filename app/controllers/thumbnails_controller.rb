class ThumbnailsController < ActionController::Base
  def update
    upload! if (!item.nil?)
    render plain: "OK"
  end

  def upload!
    Thumbnailer.new(cdn_url: thumb_url.to_cdn_s,
                    thumb_url: thumb_url.to_s).upload!
  end

  def thumb_url
    @thumb_url ||=
    Umedia::Thumbnail::Url.new(item: item)
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