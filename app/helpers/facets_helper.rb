module FacetsHelper
  def modal_query(new_param, params)
    URI.parse(facets_path(params.merge(new_param))).query
  end

  def data_controller(params)
    (params[:modal] == 'on') ? 'data-controller=searches' : ''
  end
end
