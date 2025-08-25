class SearchesController < ApplicationController
  def index
    response.headers["Content-Language"] = I18n.locale.to_s
    @facet_fields_all = facet_fields_all
    @hide_header_search_link = true

    respond_to do |format|
      format.html { render locals: locals }
      format.json { render locals: { rows: json_response} }
    end
  end

  private

  def json_response
    item_list.map { |item| Umedia::ItemWithThumb.new(item: item).to_h }
  end

  def locals
    {
      item_list: item_list,
      facet_list: facet_list,
      search_params: search_params.to_h,
      sidebar_facet_fields: facet_fields.map(&:to_s),
      pager: pager
    }
  end

  def search
    @search ||= Umedia::Search.new(
      rows: rows,
      q: search_params.fetch('q', ''),
      facet_config: facet_config,
      page: page,
      sort: sort
    ).response
  end

  def q
    search_params.fetch('q', '')
  end

  def sort
    if q.blank? && sort_param.blank?
      'title_sort ASC'
    elsif sort_param.blank?
      'score DESC,title_sort ASC'
    else
      sort_param
    end
  end

  def facet_config
    Umedia::FacetConfig.new(
      {
        params: legal_facet_params,
        fields: facet_fields_all
      }
    ).config
  end

  def rows
    search_params[:rows] ? search_params[:rows] : 20
  end

  def sort_param
    search_params[:sort]
  end

  def legal_facet_params
    facet_params.select { |field, value| facet_fields_all.include? field }
  end

  def facet_params
    search_params.to_h.fetch('facets', {}).symbolize_keys
  end

  def facet_list
    Parhelion::FacetList.new(facet_hash:
      search.fetch('facet_counts', {}).fetch('facet_fields', {}))
  end

  def item_list
    Parhelion::ItemList.new(results: search['response']['docs'])
  end

  def pager
    Parhelion::Pager.new(current_page: page,
                         rows: rows,
                         result_count: search['response']['numFound'])
  end

  def page
    search_params.fetch('page', 1).to_i
  end

  def rows
    search_params.fetch('rows', ENV['UMEDIA_SEARCH_ROWS'].to_i).to_i
  end

  def query
    Parhelion::Query.new(params: search_params)
  end

  def facet_fields_config
    Umedia::FacetFieldConfig.new
  end

  def facet_fields_all
    facet_fields_config.all
  end

  def facet_fields
    facet_fields_config.visible
  end

  def search_params
    params.permit(:json, :q, :page, :rows, :sort, facets: facet_fields_all.map { |facet| {facet => []} })
  end
end
