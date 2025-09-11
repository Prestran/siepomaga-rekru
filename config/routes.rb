Rails.application.routes.draw do
  resources :zips, only: [:create, :index]
end
