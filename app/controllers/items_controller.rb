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
        Umedia::ChildSearch.new(parent_id: id, page: child_page)
      end
    else
      Umedia::ChildSearch.new(parent_id: id, q: items_params[:query], page: child_page)
    end
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
