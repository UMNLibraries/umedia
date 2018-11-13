class ChildSearchesController < ApplicationController
  def index
    render layout: false,
           locals: { children: children,
                     child_index: child_params[:child_index] }
  end

  def children
    @children ||= Umedia::ChildSearch.new(parent_id: params.fetch(:id),
                                              include_attachments: false,
                                              search_config: search_config)
  end

  def search_config
    Parhelion::SearchConfig.new(
      q: child_params[:q],
      page: current_page,
      rows: child_rows
    )
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
    params.permit(:q, :rows, :page, :active_child_id, :child_index)
  end
end
