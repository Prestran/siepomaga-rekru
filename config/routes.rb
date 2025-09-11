Rails.application.routes.draw do
  resource :session
  resources :passwords, param: :token
  resources :zipper_files, only: [:create, :index]
end
