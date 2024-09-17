Rails.application.routes.draw do
  resources :cards

  resources :asteroids do
    collection do
      post 'fetch_and_save', to: 'asteroids#save_from_nasa'
    end
  end

  # Rota para verificação de saúde do Rails
  get "up" => "rails/health#show", as: :rails_health_check
end
