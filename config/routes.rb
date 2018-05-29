Rails.application.routes.draw do
  get 'facets/show'
  get 'facet/index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
  root to: 'searches#index'
  get 'search', to: 'searches#index', as: 'searches'
  get 'search/:id', to: 'searches#show', as: 'search'
  get 'facet/:name', to: 'facet#show', as: 'show'
end
