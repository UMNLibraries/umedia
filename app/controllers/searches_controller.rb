class SearchesController < ApplicationController
  def index
    response.headers["Content-Language"] = I18n.locale.to_s
    render locals: {response: search_response, search_params: search_params.to_h}
  end

  def search_response
    publisher = facet_params.fetch(:publisher, false)
    year_range = facet_params.fetch(:year_range, false)
    # Card.search do
    #   fulltext search_params.to_h.fetch(:q, '*:*'), {highlight: [:ocr]}
    #   order_by(:file_name, :asc) if search_params[:sort] == 'file_name_asc'
    #   order_by(:file_name, :desc) if search_params[:sort] == 'file_name_desc'
    #   order_by(:score, :asc) if search_params[:sort] == 'relevance'

    #   with(:publisher, publisher) if publisher
    #   with(:year_range, year_range) if year_range
    #   paginate(:page => search_params[:page], :per_page => 5)
    #   facet :publisher, :year_range
    # end

    SolrConnection.new.solr.paginate 1, 10,  'select', :params => {
      q: (q != '' ? q : '*:*'),
      fq: "record_type:primary",
      start: search_params[:page],
      row: search_params.fetch(:rows, 10)
    }
  end

  def q
    @q ||= search_params.to_h.fetch(:q, '*:*')
  end

  def show
    # @card = Card.find(params[:id])
  end

  def show
    # @card = Card.find(params[:id])
  end

  def facet_params
    search_params.to_h.fetch('facets', {}).symbolize_keys
  end

  def query
    Parhelion::Query.new(params: search_params)
  end

  def search_params
    params.permit(:q, :page, :rows, :sort, facets: [:publisher, :year_range])
  end
end
