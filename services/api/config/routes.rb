Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'home#index'

  resource :game, only: [:show, :create]

  post '/game/word', to: 'games#add_word'

  get '/game/results', to: 'games#get_results'
end
