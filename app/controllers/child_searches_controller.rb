class ChildSearchesController < ApplicationController
  def index
    respond_to do |format|
      format.html {
        render layout: false,
               locals: { child_search: child_search }
      }
      format.json {
        render format: [:json],
               locals: { child_search: child_search }
      }
    end
  end

  def child_search
    @child_search ||= Umedia::ChildSearch.new(parent_id: params.fetch(:id),
                                              q: child_params[:q],
                                              page: current_page,
                                              rows: child_rows)
  end

  def child_rows
    rows < 100 && rows > 0 ? child_params[:rows] : 3
  end

  def rows
    child_params[:rows].to_i
  end

  def current_page
    child_params[:page] ? child_params[:page] : 1
  end

  def child_params
    params.permit(:q, :rows, :page, :active_child_id, :id)
  end
end
