class CollectionsController < ApplicationController
  def index
    @pager = pager
    @sort_list = sort_list
    @collection_params = collection_params.to_h
    @collections = collection_search.docs
    @num_found = collection_search.num_found
    render layout: false if collection_params[:nolayout]
  end

  def collection_search
    @collection_search ||=
      Umedia::CollectionSearch.new(q: collection_params.fetch(:filter_q, ''),
                                   page: collection_params.fetch(:page, 1),
                                   sort: sort)
  end

  def pager
    Parhelion::Pager.new(
      current_page: collection_params.fetch(:page, 1).to_i,
      rows: collection_search.rows,
      result_count: collection_search.num_found)
  end

  def sort
    if collection_params[:sort].blank?
      'set_spec desc'
    else
      collection_params[:sort]
    end
  end

  def page
    collection_params.fetch(:page, 1)
  end

  def sort_list
    Umedia::SortList.new(query: Parhelion::Query.new(params: collection_params),
                         mappings: sort_mappings)
  end

  def sort_mappings
    [
      {label: 'Most Recently Added Collection', sort: 'set_spec desc' },
      {label: 'Collection Name: A to Z', sort: 'collection_name_s asc' },
      {label: 'Collection Name: Z to A', sort: 'collection_name_s desc' }
    ]
  end

  def collection_params
    params.permit(:page, :sort, :nolayout, :filter_q)
  end
end
