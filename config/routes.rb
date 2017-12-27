Ecommerce::Engine.routes.draw do

  namespace :backoffice do
    resources :brands
  end
  namespace :backoffice do
    get 'dashboard', :to => "dashboard#main"
    resources :users
    resources :controls
    resources :categories
    resources :products
    resources :product_variants
    resources :product_skus
    resources :product_sku_properties
    resources :addresses
    resources :orders
  end

  root to: 'store#main'

end
