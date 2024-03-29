class ItemsController < SearchesController
  after_action :set_access_control_headers

  def set_access_control_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
    headers['Access-Control-Request-Method'] = '*'
    headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
  end

  def show
    response.headers['Content-Language'] = I18n.locale.to_s
    @child_page_num = child_page_num
    @items_params = items_params
    @show_sidebar_slider = show_sidebar_slider
    @page_count = page_count
    @item ||= ItemPresenter.new(item, view_context)
    @sidebar ||= ViewerSidebarPresenter.new(children, view_context)
    @mlt_items = mlt_items
    respond_to do |format|
      format.html
      format.json { @json_item = json_item }
    end
  end

  def json_item
    item_with_thumb.merge(children: children_with_thumbs)
  end

  def item_with_thumb
    Umedia::ItemWithThumb.new(item: @item).to_h
  end

  def children_with_thumbs
    children.items.map { |child| Umedia::ItemWithThumb.new(item: child).to_h }
  end

  def show_sidebar_slider
    page_count > ENV['SIDEBAR_SLIDER_PAGE_COUNT_THRESHOLD'].to_i
  end

  def page_count
    @page_count ||= item.field_page_count.value
  end

  def mlt_items
    Umedia::MltSearch.new(id: id, rows: 6).items
  end

  def item
    Rails.cache.fetch("item/#{id}") do
      Umedia::ItemSearch.new(id: id).item
    end
  end

  def children
    @children ||= search(search_params.merge(q: items_params.fetch(:query, ''), rows: 5000))
  end

  def search(params)
    Umedia::ChildSearch.new(parent_id: id,
                            # Attachments are things like transcripts; these
                            # exist only on kaltura records or items that have
                            # been explicitly set at the designated attachment.
                            # We do not therefore want attachments to be
                            # counted in sidebar queries
                            include_attachments: false,
                            search_config: Parhelion::SearchConfig.new(params))
  end

  def child_page_num
    params.fetch(:child_page, 1)
  end

  def search_params
    {
      page: child_page_num,
      # we only need the first result of a sidebar query; this is passed to
      # viewer_controller.js so that it knows which child to display on load
      rows: 1,
      fl: '*'
    }
  end

  def id
    params[:id]
  end

  def facet_fields_all
    Umedia::FacetFieldConfig.new.all
  end

  def items_params
    params.permit(:query, :language, :child_page, :q, :page, :rows, :sort, facets: facet_fields_all.map { |facet| {facet => []} })
  end
end
