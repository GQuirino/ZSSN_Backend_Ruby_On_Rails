Rails.application.routes.draw do
  root 'survivors#index'

  get 'reports/infected', to: 'reports#infected'
  get 'reports/non-infected', to: 'reports#non_infected'

  resources :survivors, only: %i[index create update show]
  # get 'survivors/', to: 'survivors#index'
  # post 'survivors/', to: 'survivors#create'
  # put 'survivors/:id', to: 'survivors#update'

  # put 'infection/:idSurvivor', to: 'infection#new'

 # post 'trade', to: 'trade#new'
end
