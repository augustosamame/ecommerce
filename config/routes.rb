Ecommerce::Engine.routes.draw do

  namespace :backoffice do
    get 'dashboard'
    resources :users
    resources :controls
    resources :products
    resources :product_variants
    resources :product_skus
    resources :product_sku_properties
    resources :orders
  end

  root to: 'store#main'

end
