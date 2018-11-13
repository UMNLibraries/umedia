module MetadataHelper

  def index_id
    @item.index_id
  end

  def attachment_format
    @item.field_attachment_format.value
  end

  def has_field?(field)
    !Umedia::FieldData.new(parent_id: index_id,
                           field: field,
                           check_exists: true).empty?
  end

  def attachement_label
    case attachment_format
    when 'pdf'
      'PDF Transcript'
    when 'image'
      'Attached Image'
    else
      'Attachment'
    end
  end
end
