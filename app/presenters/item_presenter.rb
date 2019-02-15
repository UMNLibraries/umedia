class ItemPresenter < BasePresenter
  def page_title
    field_title.value
  end

  def image?
    # We use first_viewer_type instead of just viewer_type because there are
    # records stored as compounds in CONTENTdm that are compounds with only
    # a single page. These are displayed in UMedia as single pages. In this
    # case, we want the type of the first child or single parent, which is
    # what is stored in first_viewer_type
    # Yes, it would have been nice if everything in CDM was a "compound" and
    # we didn't have to write all this code to handle special cases.
    field_first_viewer_type.value == 'image'
  end

  def item_anchor
    index_id
  end

  def download_config
    Umedia::Download.new(item: download_item)
  end

  def link_params(search_params)
    { controller: 'searches',
      action: 'index',
      anchor: "#{item_anchor}"
    }.merge(search_params)
  end

  private

  def download_item
    is_compound? ? first_child : self
  end

  def first_child
    Umedia::ChildSearch.new(
      parent_id: index_id,
      search_config: Parhelion::SearchConfig.new(q: '*:*', rows: 1)
    ).items.first
  end
end
