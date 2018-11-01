require 'net/http'

module MetadataHelper
  def has_transcript?(id)
    field_data(id, 'transcription')
  end

  def has_translation?(id)
    field_data(id, 'translation')
  end

  def field_data(id, field)
    Umedia::FieldData.new(id: id,
                          field: field,
                          check_exists: true).data.first
  end
end
