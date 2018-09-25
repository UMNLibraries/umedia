Rails.application.routes.draw do
  get 'child_searches/index'
  get 'items/show'
  get 'facets', to: 'facets#index', as: 'facets'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'
  root to: 'searches#index'
  get 'search', to: 'searches#index', as: 'searches'
  get 'item/:id/(:child_id)', to: 'items#show', as: 'item'
  get 'downloads/:id', to: 'downloads#show', as: 'downloads'
  get 'viewers/:id/(:child_id)', to: 'viewers#show', as: 'viewer'
  get 'child_search/:id/:active_child_id/:rows/(:q)', to: 'child_searches#index', as: 'child_search'
  get 'thumbnails/:item_id' => 'thumbnails#update', as: 'thumbnail'
end
