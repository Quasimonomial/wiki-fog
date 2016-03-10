Rails.application.routes.draw do
  root 'wikipedia#index'
  post 'wikipedia' => 'wikipedia#create'
end
