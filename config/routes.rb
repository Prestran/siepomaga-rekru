Rails.application.routes.draw do
  resources :zipper_files, only: [ :create, :index ]
  devise_for :users, path: '', path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    registration: 'signup'
  },
   controllers: {
     sessions: 'users/sessions',
     registrations: 'users/registrations'
   }
end
