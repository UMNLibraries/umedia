class SearchesController < ApplicationController
  def index
    response.headers["Content-Language"] = I18n.locale.to_s
    render locals: {
      item_list: item_list,
      facet_list: facet_list,
      search_params: search_params.to_h,
      sidebar_facet_fields: facet_fields.map(&:to_s),
      pager: pager
    }
  end

  private

  def search
    @search ||= Umedia::Search.new(
      rows: rows,
      q: search_params.fetch('q', ''),
      facet_params: facet_params,
      facet_fields: facet_fields_all,
      page: page,
      sort: sort,
      rows: rows
    ).response
  end

  def rows
    search_params[:rows] ? search_params[:rows] : 20
  end

  def sort
    search_params.fetch(:sort, 'score desc, title desc')
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
    search_params.fetch('rows', 50).to_i
  end

  def query
    Parhelion::Query.new(params: search_params)
  end

  def facet_fields
    [
      :types,
      :format_name,
      :date_created_ss,
      :subject_ss,
      :creator_ss,
      :publisher_s,
      :contributor_ss,
      :collection_name_s,
      :page_count
    ]
  end


  def facet_fields_hidden
    [
      :format_name,
      :subject_fast_ss,
      :city,
      :state,
      :country,
      :region,
      :continent,
      :parent_collection_name,
      :contributing_organization_name
    ]
  end

  def facet_fields_all
    facet_fields.concat(facet_fields_hidden)
  end

  def search_params
    params.permit(:q, :page, :rows, :sort, facets: facet_fields_all.map { |facet| {facet => []} })
  end
end
