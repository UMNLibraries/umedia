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
    render locals: { document: document,
                     children: children,
                     search_params: search_params}
  end

  def document
    Rails.cache.fetch("document/#{id}") do
      Umedia::DocumentSearch.new(id: id).document
    end
  end

  def children
    if !has_search?
      Rails.cache.fetch("compound_children/#{id}") do
        Umedia::ChildSearch.new(parent_id: id)
      end
    else
      Umedia::ChildSearch.new(parent_id: id, q: items_params[:query])
    end
  end

  def id
    params.fetch(:id)
  end

  def has_search?
    items_params.fetch(:query, '') != ''
  end

  def items_params
    params.permit(:query)
  end
end
