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
  get '/category/:id', :to => 'store#shop_by_category', :as => 'category'
  get '/product/:id', :to => 'store#product_detail', :as => 'product'

  resources :carts, except: [:index, :new, :create]
  resources :cart_items

  root to: 'store#main'

end
