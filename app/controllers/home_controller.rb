class HomeController < ApplicationController
  def show
    @pager = pager
    @home_params = home_params.to_h
    @sort_list = sort_list
    @facet_fields_all = []
    @count = count
    @collection_rows = collection_rows
  end

  def pager
    Parhelion::Pager.new(
      current_page: home_params.fetch(:page, 1).to_i,
      rows: collection_rows,
      result_count: num_found)
  end

  def sort_list
    Umedia::SortList.new(query: Parhelion::Query.new(params: home_params),
                         mappings: sort_mappings)
  end

  def count
    Rails.cache.fetch("item_count", expires_in: 12.hours) do
      Umedia::RecordCountSearch.new.count
    end
  end

  def sort_mappings
    [
      {label: 'Most Recently Added Collection', sort: 'set_spec desc' },
      {label: 'Collection Name: A to Z', sort: 'collection_name_s asc' },
      {label: 'Collection Name: Z to A', sort: 'collection_name_s desc' }
    ]
  end

  def sort
    home_params.fetch(:sort, 'set_spec desc')
  end

  def num_found
    @num_found ||=
      Umedia::CollectionSearch.new(page: home_params[:page],
                                   sort: sort,
                                   rows: 20).num_found
  end

  def home_params
    params.permit(:page, :sort)
  end

  def collection_rows
    20
  end
end
