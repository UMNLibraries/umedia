require 'net/http'

module MetadataHelper
  def has_transcript?(id)
    transcription(id).field_transcription.value
  end

  def has_translation?(id)
    translation(id).field_translation.value
  end

  def transcription(id)
    Umedia::Transcription.new(id: id, check_exists: true).transcriptions.first
  end

  def translation(id)
    Umedia::Translation.new(id: id, check_exists: true).translations.first
  end
end
