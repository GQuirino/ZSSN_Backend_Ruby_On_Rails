Rails.application.routes.draw do
  root 'survivors#index'

  get 'reports/infected', to: 'reports#infected'
  get 'reports/non-infected', to: 'reports#nonInfected'

  resource :survivors, only: [:index, :create, :update]
  # get 'survivors/', to: 'survivors#index'
  # post 'survivors/', to: 'survivors#create'
  # put 'survivors/:idSurvivor', to: 'survivors#update'

  put 'infection/:idSurvivor', to: 'infection#new'

  post 'trade', to: 'trade#new'
end
