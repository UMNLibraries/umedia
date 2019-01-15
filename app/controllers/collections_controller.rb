class CollectionsController < ApplicationController
  def index
    @collections = collection_search.docs
    @num_found = collection_search.num_found
    render layout: false if collection_params[:nolayout]
  end

  def collection_search
    @collection_search ||=
      Umedia::CollectionSearch.new(page: collection_params[:page],
                                   sort: sort,
                                   rows: legal_rows)
  end

  def sort
    @sort ||= collection_params.fetch(:sort, 'set_spec desc')
  end

  def page
    collection_params.fetch(:page, 1)
  end

  def collection_params
    params.permit(:page, :sort, :nolayout, :rows)
  end

  def legal_rows
    rows <= 20 ? rows : 20
  end

  # TODO: turn this into a param
  def rows
    collection_params.fetch(:rows, 20).to_i
  end
end
