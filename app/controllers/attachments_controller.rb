class AttachmentsController < ApplicationController
  def show
    render layout: false,
           locals: { item: item, viewer_item: viewer_item }
  end

  def viewer_item
    @viewer_doc ||= Parhelion::Viewers::OpenSeadragon.new(item: item)
  end

  def item
    @item ||=
      Umedia::FieldData.new(parent_id: params[:id],
                            field: 'attachment_format').items.first
  end
end
