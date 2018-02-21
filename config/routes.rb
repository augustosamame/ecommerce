Ecommerce::Engine.routes.draw do

  namespace :backoffice do
    get 'dashboard', :to => "dashboard#main"
    resources :users
    resources :brands
    resources :suppliers
    resources :controls
    resources :categories
    resources :products
    resources :product_variants
    resources :product_skus
    resources :product_sku_properties
    resources :properties
    resources :addresses
    resources :orders
  end

  post 'locale', :to => 'application#locale'
  get 'category', :to => 'store#shop_by_category'
  get 'product', :to => 'store#product_detail'


  root to: 'store#main'

end
