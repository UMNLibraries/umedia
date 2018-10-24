class CitesController < ApplicationController
  def show
    render layout: false,
           locals: { item: Umedia::Item.find(params.fetch(:id)) }
  end
end
