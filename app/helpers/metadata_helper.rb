module MetadataHelper
  def has_field?(field, id)
    !Umedia::FieldData.new(parent_id: id,
                           field: field,
                           check_exists: true).empty?
  end

  def attachement_label(type)
    case type
    when 'pdf'
      'PDF Transcript'
    when 'image'
      'Attached Image'
    else
      'Attachment'
    end
  end
end
