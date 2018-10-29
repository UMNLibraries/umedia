require 'net/http'

module MetadataHelper
  def has_transcript?(id)
    !Umedia::Transcription.new(id: id,
                               check_exists: true).transcriptions.empty?
  end

  def has_translation?(id)
    !Umedia::Translation.new(id: id,
                             check_exists: true).translations.empty?
  end
end
