class DetailsController < ApplicationController
  def show
    render layout: false,
           locals: {
             item: Umedia::Item.find(params.fetch(:id)),
             locale: params.fetch(:language, :en).to_sym
           }
  end
end
