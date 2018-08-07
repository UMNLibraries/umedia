class ViewersController < ApplicationController
  def show
    render layout: false,
           locals: { viewer_item: viewer_item }
  end

  def viewer_item
    @viewer_doc ||= Parhelion::Viewers::Map.new(item: active_doc).to_viewer
  end

  def active_doc
    if child_id
      item(child_id)
    elsif primary_item.is_compound?
      children.first
    else
      primary_item
    end
  end

  def item(id)
    Rails.cache.fetch("item/#{id}") do
      Umedia::ItemSearch.new(id: id).item
    end
  end

  def children
    Rails.cache.fetch("compound_children_complete/#{params.fetch(:id)}") do
      Umedia::ChildSearch.new(parent_id: params.fetch(:id), fl: '*').items
    end
  end

  def primary_item
    @doc ||= item(params.fetch(:id))
  end

  def child_id
    params.fetch(:child_id, false)
  end
end
