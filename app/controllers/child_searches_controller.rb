class ChildSearchesController < ApplicationController
  def index
    render layout: false,
           locals: { children: children,
                     page_count: page_count,
                     child_index: child_params[:child_index] }
  end

  def children
    @children ||= Umedia::ChildSearch.new(parent_id: params.fetch(:id),
                                          include_attachments: false,
                                          search_config: search_config)
  end

  def show_sidebar_slider
    page_count > 100
  end

  def page_count
    @page_count ||= item.field_page_count.value
  end

  def item
    @item ||= Umedia::ItemSearch.new(id: params.fetch(:id)).item
  end

  def search_config
    Parhelion::SearchConfig.new(
      q: child_params[:q],
      page: current_page,
      rows: child_rows
    )
  end

  def child_rows
    return 5000 if page_count <= ENV['SIDEBAR_SLIDER_PAGE_COUNT_THRESHOLD'].to_i

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
