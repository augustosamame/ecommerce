Ecommerce::Engine.routes.draw do

  namespace :backoffice do
    resources :products
  end
  root to: 'store#main'

end
