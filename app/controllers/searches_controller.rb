# TODO: refactor search code into a service class
class SearchesController < ApplicationController
  def index
    response.headers["Content-Language"] = I18n.locale.to_s
    render locals: {
      document_list: document_list,
      search_params: search_params.to_h,
      pager: pager,
      facet_list: facet_list
    }
  end

  def search
    publisher = facet_params.fetch(:publisher, false)
    year_range = facet_params.fetch(:year_range, false)
    rows = search_params.fetch(:rows, 50).to_i
    @search ||= SolrConnection.new.solr.paginate 1, rows,  'search', :params => {
      q: search_params[:q],
      'q.alt': '*:*',
      'facet.field': facets,
      'facet.limit': 15,
      fq: ["record_type:primary"].concat(facet_query),
      start: search_params[:page].to_i,
      row: rows
    }
    @search
  end

  def facets
    [
      'type',
      'format',
      'date_created_ss',
      'subject_ss',
      'creator_ss',
      'publisher_s',
      'contributor_ss',
      'parent_collection_s'
    ]
  end

  def facet_list
    Parhelion::FacetList.new(facet_hash: facet_field_results)
  end

  def facet_field_results
    search.fetch('facet_counts', {}).fetch('facet_fields', {})
  end

  def search_facets
    search.fetch('facet_counts', {})
  end

  def document_list
    Parhelion::DocumentList.new(results: search['response']['docs'],
                                num_found: search['response']['numFound'],
                                start: search['response']['start'],
                                field_order: %w[id title])
  end

  def q
    @q ||= search_params.to_h.fetch(:q, '*:*')
  end

  def pager
    Parhelion::Pager.new(active_page: page,
                         rows: rows,
                         result_count: document_list.num_found)
  end

  def page
    search_params.fetch('page', 1).to_i
  end

  def rows
    search_params.fetch('rows', 50).to_i
  end

  def facet_query
    facet_params.keys.map { |key| "#{key}:\"#{facet_params[key]}\"" }
  end

  def facet_params
    search_params.to_h.fetch('facets', {}).symbolize_keys
  end

  def query
    Parhelion::Query.new(params: search_params)
  end

  def search_params
    params.permit(:q, :page, :rows, :sort, facets: facets)
  end
end
