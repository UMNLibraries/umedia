module MetadataHelper
  def has_field?(field, id)
    !Umedia::FieldData.new(parent_id: id,
                           field: field,
                           check_exists: true).empty?
  end
end
