Rails.application.routes.draw do
  resource :session
  resources :zipper_files, only: [:create, :index]
end
