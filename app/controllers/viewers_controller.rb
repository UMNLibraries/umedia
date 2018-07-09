class ViewersController < ApplicationController
  def show
    render layout: false,
           locals: { viewer_document: viewer_document }
  end

  def viewer_document
    @viewer_doc ||= Parhelion::Viewers::Map.new(document: active_doc).to_viewer
  end

  def active_doc
    if child_id
      document(child_id)
    elsif primary_document.is_compound?
      children.first
    else
      primary_document
    end
  end

  def document(id)
    Rails.cache.fetch("document/#{id}") do
      Umedia::DocumentSearch.new(id: id).document
    end
  end

  def children
    Rails.cache.fetch("compound_children_complete/#{params.fetch(:id)}") do
      Umedia::ChildSearch.new(parent_id: params.fetch(:id), fl: '*').documents
    end
  end

  def primary_document
    @doc ||= document(params.fetch(:id))
  end

  def child_id
    params.fetch(:child_id, false)
  end
end
