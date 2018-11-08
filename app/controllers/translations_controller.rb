class TranslationsController < ApplicationController
  def show
    render layout: false,
           locals: { translations: translations }
  end

  def translations
    @transcrips ||=
      Umedia::FieldData.new(parent_id: params[:id], field: 'translation').items
  end
end
