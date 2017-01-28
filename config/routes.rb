SwaggerEngine::Engine.routes.draw do
  resources :swaggers, only: [:index, :show]
  get 'swaggers/*id', to: 'swaggers#show'
  root to: 'swaggers#index'
end
