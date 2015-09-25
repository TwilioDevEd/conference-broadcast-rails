Rails.application.routes.draw do

  post "conference", to: 'twilio#join_conference'
  get "conference", to: 'twilio#conference'
  post "conference/connect", to: 'twilio#conference_connect'
  post "broadcast", to: 'twilio#broadcast'

  get "broadcast", to: 'twilio#broadcast'
  post "broadcast/record", to: 'twilio#broadcast_record'
  post "broadcast/send", to: 'twilio#broadcast_send'
  post "broadcast/play", to: 'twilio#broadcast_play'
  get "fetch_recordings", to: 'twilio#fetch_recordings'
  post "call_recording", to: 'twilio#start_call_record'

  # Home page
  root 'main#index', as: 'home'
end
