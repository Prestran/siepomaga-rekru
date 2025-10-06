Rails.application.routes.draw do
  resources :zipper_files, only: [ :create, :index ]
  devise_for :users
end
