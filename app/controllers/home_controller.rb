class HomeController < ApplicationController
  def show
    @pager = pager
    @home_params = home_params.to_h
  end

  def pager
    Parhelion::Pager.new(current_page: home_params.fetch(:page, 1).to_i,
      rows: 10,

      result_count: num_found)
  end

  def num_found
    @num_found ||=
      Umedia::CollectionSearch.new(page: home_params[:page],
                                   rows: 10).num_found
  end

  def home_params
    params.permit(:page, :sort)
  end
end
