Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'
  devise_for :users

  get "up" => "rails/health#show", as: :rails_health_check

  get "dashboard", to: "dashboard#show"

  resources :cnab_transactions, only: [:new, :create]

  devise_scope :user do
    authenticated :user do
      root "dashboard#show", as: :authenticated_root
    end
    unauthenticated do
      root "devise/sessions#new", as: :unauthenticated_root
    end
  end
end
