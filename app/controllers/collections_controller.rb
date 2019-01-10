class CollectionsController < ApplicationController
  def index
    @collections = collection_search.docs
    @num_found = collection_search.num_found
    @show_navbar_search = true
    render layout: false if collection_params[:nolayout]
  end

  def collection_search
    @collection_search ||=
      Umedia::CollectionSearch.new(page: collection_params[:page],
                                   sort: sort,
                                   rows: rows)
  end

  def sort
    @sort ||= collection_params.fetch(:sort, 'set_spec desc')
  end

  def page
    collection_params.fetch(:page, 1)
  end

  def collection_params
    params.permit(:page, :sort, :nolayout)
  end

  def rows
    20
  end
end
