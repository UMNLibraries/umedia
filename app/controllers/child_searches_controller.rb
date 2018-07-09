class ChildSearchesController < ApplicationController
  def index
    render layout: false,
           locals: { children: children }
  end

  def children
    @search ||= Umedia::ChildSearch.new(parent_id: params.fetch(:id),
                                        q: child_search_params[:q])
  end

  def child_search_params
    params.permit(:q)
  end
end
