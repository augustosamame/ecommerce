Ecommerce::Engine.routes.draw do

  namespace :backoffice do
    resources :product_skus
  end
  namespace :backoffice do
    resources :product_variants
  end
  namespace :backoffice do
    resources :products
  end
  root to: 'store#main'

end
