class ItemPresenter < BasePresenter
  def page_title
    field_title.value
  end

  def image?
    type == 'Still Image'
  end

  def item_anchor
    index_id
  end

  def download_config
    Umedia::Download.new(item: self)
  end

  def link_params(search_params)
    { controller: 'searches',
      action: 'index',
      anchor: "#{item_anchor}"
    }.merge(search_params)
  end
end