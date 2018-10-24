class TranscriptionsController < ApplicationController
  def show
    render layout: false,
           locals: { transcriptions: transcrips }
  end

  def transcrips
    @transcrips ||=
      Umedia::Transcription.new(id: params[:id]).transcriptions
  end
end
