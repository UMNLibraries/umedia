class DownloadsController < ActionController::Base
  def show
    render locals: { downloads: downloads }
  end

  def downloads
    Rails.cache.fetch("downloads/#{id}") do
      Umedia::Download.new(item: item)
    end
  end

  def item
    Rails.cache.fetch("item/#{id}") do
      Umedia::ItemSearch.new(id: id).item
    end
  end

  def id
    params.fetch(:id)
  end
end