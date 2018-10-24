require 'net/http'

module MetadataHelper
  def has_transcript?(id)
    !Umedia::Transcription.new(id: id,
                               check_exists: true).transcriptions.empty?
  end
end
