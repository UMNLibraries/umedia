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
    @item ||= ItemPresenter.new(item, view_context)
    @sidebar ||= ViewerSidebarPresenter.new(children, view_context)
  end

  def item
    Rails.cache.fetch("item/#{id}") do
      Umedia::ItemSearch.new(id: id).item
    end
  end

  def children
    @children ||= search(search_params.merge(q: items_params.fetch(:query, '')))
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
    params.permit(:query, :child_page, :q, :page, :rows, :sort, facets: facet_fields_all.map { |facet| {facet => []} })
  end
end
