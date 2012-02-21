Albipes::Application.routes.draw do

  resources :round
  match '/companies/search' => 'companies#search'
  match '/companies/:id/subscribe' => 'companies#subscribe'
  match '/unsubscribe' => 'companies#unsubscribe'
  resources :companies
  root :to => 'companies#index'
  match '/people/:id' => 'people#show'
end
