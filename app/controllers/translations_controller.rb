class TranslationsController < ApplicationController
  def show
    render layout: false,
           locals: { translations: translations }
  end

  def translations
    @transcrips ||=
      Umedia::Translation.new(id: params[:id]).translations
  end
end
