Rails.application.routes.draw do
  root 'static_pages#home'
  resources :decks, shallow: true do
    resources :cards
  end
  resources :reviews, only: :create
  get 'reviews', to: 'reviews#new'
  resources :registrations, only: :create do
    member do
      get :activate
    end
  end
  get 'signup', to: 'registrations#new'
  resource :profile, only: [:show, :edit, :update]
  resources :sessions, only: :create
  get 'login', to: 'sessions#new'
  post 'logout', to: 'sessions#destroy'
  resources :reset_passwords, only: [:create, :update, :edit]
  get 'reset_passwords', to: 'reset_passwords#new'
  post "oauth/callback", to: 'oauths#callback'
  get "oauth/callback", to: 'oauths#callback'
  get "oauth/:provider", to: 'oauths#oauth', :as => :auth_at_provider
  delete "oauth/:provider", to: "oauths#destroy", :as => :delete_oauth
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
