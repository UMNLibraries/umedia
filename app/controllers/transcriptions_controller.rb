class TranscriptionsController < ApplicationController
  def show
    render layout: false,
           locals: { transcriptions: transcrips }
  end

  def transcrips
    @transcrips ||=
      Umedia::FieldData.new(parent_id: params[:id], field: 'transcription').items
  end
end
