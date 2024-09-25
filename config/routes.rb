# frozen_string_literal: true

Rails.application.routes.draw do
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get 'up' => 'rails/health#show', as: :rails_health_check

  # TODO: Add admin constraints
  mount Sidekiq::Web => '/sidekiq'

  # API Documentation
  mount Rswag::Ui::Engine => 'api-docs'
  mount Rswag::Api::Engine => 'api-docs'

  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      resources :users, only: [ :index ]

      # This must be the last route definition under the namespace
      # to catch-all route to handle missing routes
      match '*unmatched_route', to: 'base#route_not_found', via: :all
    end
  end

  # We can consider universal catch-all route here later
end
