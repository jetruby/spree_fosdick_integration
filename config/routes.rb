Spree::Core::Engine.routes.draw do
  namespace :admin do
    resources :fosdick_shipments, only: [:index] do
      collection do
        post :update_positions
      end
    end
  end
end
