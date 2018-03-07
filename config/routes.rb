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
    post '/orders/einvoice'
  end

  post 'locale', :to => 'application#locale'
  #get '/category/:id', :to => 'store#shop_by_category', :as => 'category'
  #get '/product/:id', :to => 'store#product_detail', :as => 'product'
  resources :products, only: [:index, :show]
  post '/checkout/pay_order_culqi_checkout', :to => 'checkout#pay_order_culqi_checkout'
  get '/checkout', :to => 'checkout#show'
  get '/my_account', :to => 'users#show'

  post '/calculate_shipping', :to => 'integrations#get_shipping_quote'

  resources :carts, except: [:index, :new, :create]
  resources :cart_items
  patch '/addresses/update_map', to: 'addresses#update_map'
  resources :addresses


  root to: 'store#main'

end
