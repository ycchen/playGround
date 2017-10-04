Rails.application.routes.draw do
  root to: 'notifications#index'
  resources :messages
  get 'notifications/index'

  resources :products
  resources :employees
  resources :accounts
  resources :suppliers
  resources :books
  resources :authors
  resources :comments
  resources :posts

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
	get 'messaging' => 'messaging#send_message'

  # Websockets resemble this URL
  mount ActionCable.server => '/cable'
end
