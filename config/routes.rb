Rails.application.routes.draw do
  root 'survivors#index'

  get 'reports/infected', to: 'reports#infected'
  get 'reports/non-infected', to: 'reports#non_infected'

  resources :survivors, only: %i[index create update show]

  put 'infection/:id', to: 'infections#update'

  put 'trade/:id_survivor_from/to/:id_survivor_to', to: 'trades#update'
end
