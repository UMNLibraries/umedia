class SearchesController < ApplicationController
  def index
    response.headers["Content-Language"] = I18n.locale.to_s
    render locals: {
      document_list: document_list,
      facet_list: facet_list,
      search_params: search_params.to_h,
      pager: pager
    }
  end

  private

  def search
    @search ||= Umedia::Search.new(
      rows: rows,
      q: search_params.fetch('q', ''),
      facet_params: search_params.to_h.fetch('facets', {}).symbolize_keys,
      facet_fields: facet_fields,
      page: page
    ).response
  end

  def facet_list
    Parhelion::FacetList.new(facet_hash:
      search.fetch('facet_counts', {}).fetch('facet_fields', {}))
  end

  def document_list
    Parhelion::DocumentList.new(results: search['response']['docs'],
                                field_order: %w[id title])
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
      :type,
      :format,
      :date_created_ss,
      :subject_ss,
      :creator_ss,
      :publisher_s,
      :contributor_ss,
      :parent_collection_s
    ]
  end

  def search_params
    params.permit(:q, :page, :rows, :sort, facets: facet_fields)
  end
end
