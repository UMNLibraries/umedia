class HomeController < ApplicationController
  def show
    @home_params = home_params.to_h
    @facet_fields_all = []
    @hide_header_search_link = true
  end

  def sort
    home_params.fetch(:sort, 'set_spec desc')
  end

  def num_found
    @num_found ||= collection_search.num_found
  end

  def collection_search
    @collection_search ||=
      Umedia::CollectionSearch.new(page: home_params[:page], sort: sort)
  end

  def home_params
    params.permit(:page, :sort, :filter_q)
  end
end
