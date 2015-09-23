Rails.application.routes.draw do

  post "conference", to: 'twilio#join_conference'
  get "conference", to: 'twilio#conference'
  post "conference/connect", to: 'twilio#conference_connect'
  post "broadcast", to: 'twilio#broadcast'

  # Home page
  root 'main#index', as: 'home'
end
