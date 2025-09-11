Rails.application.routes.draw do
  resources :zipper_files, only: [:create, :index]
end
