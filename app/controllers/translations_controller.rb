class TranslationsController < ApplicationController
  def show
    render layout: false,
           locals: { translations: translations }
  end

  def translations
    @transcrips ||=
      Umedia::FieldData.new(id: params[:id], field: 'translation').data
  end
end
