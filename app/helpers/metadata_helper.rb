module MetadataHelper
  def has_field?(field, id)
    !Umedia::FieldData.new(id: id,
                           field: field,
                           check_exists: true).items.empty?
  end
end
