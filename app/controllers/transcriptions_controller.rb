class TranscriptionsController < ApplicationController
  def show
    render layout: false,
           locals: { transcriptions: transcrips }
  end

  def transcrips
    @transcrips ||=
      Umedia::FieldData.new(id: params[:id], field: 'transcription').data
  end
end
