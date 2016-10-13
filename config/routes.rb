Rails.application.routes.draw do
  root to: 'visitors#index'
  resources :accounts
  resources :restaurants
  resources :claims
  resources :dg_imports
  resources :questions do
    resources :options
  end
  devise_for :users, :controllers => { registrations: 'registrations' }

  post 'reset-password', to: 'visitors#generate_new_password_email', as: :reset_password
  get 'contact', to: 'pages#contact'
  post 'contact-submission', to: 'pages#contact_submission'
  get 'about', to: 'pages#about'
  get 'term', to: 'pages#term'

  namespace :api do
    namespace :v1 do
      post 'search', to: 'api#search'
      get  'questions', to: 'api#questions'
      get  'cuisines', to: 'api#cuisines'
      get  'myratings', to: 'api#myratings'
      get  'restaurant-ratings/:id', to: 'api#restaurant_ratings'
      get  'myrestaurants', to: 'api#myrestaurants'
      get  'restaurant/:factual_id', to: 'api#restaurant'
      post 'suggest-restaurant', to: 'api#suggest_restaurant'
      post 'update-restaurant', to: 'api#update_restaurant'
      post 'claim-restaurant', to: 'api#claim_restaurant'
      post 'submit-rating', to: 'api#submit_rating'
      get  'get-client-address', to: 'api#get_client_address'
      post 'submit-food-poisoning-report', to: 'api#submit_food_poisoning_report'
    end
  end
end
