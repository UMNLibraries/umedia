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
    render locals: { item: item,
                     children: children,
                     search_params: search_params,
                     child_page: child_page }
  end

  def child_page
    (items_params[:child_page]) ? items_params[:child_page] : 1
  end

  def item
    Rails.cache.fetch("item/#{id}") do
      Umedia::ItemSearch.new(id: id).item
    end
  end

  def children
    if !has_search?
      Rails.cache.fetch("compound_children/#{id}") do
        search(search_params)
      end
    else
      search(search_params.merge(q: items_params[:query]))
    end
  end

  def search(params)
    Umedia::ChildSearch.new(parent_id: id,
                            search_config: Parhelion::SearchConfig.new(params))
  end

  def search_params
    {
      page: child_page,
      rows: 3,
      fl: '*'
    }
  end

  def id
    params.fetch(:id)
  end

  def has_search?
    items_params.fetch(:query, '') != ''
  end

  def items_params
    params.permit(:query, :child_page)
  end
end
