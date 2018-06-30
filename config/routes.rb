Ecommerce::Engine.routes.draw do

  namespace :backoffice do
    get 'dashboard', :to => "dashboard#main"
    resources :users
    resources :brands
    resources :sliders
    put '/sliders_in_place/:id' => 'sliders#best_in_place_update'
    resources :suppliers
    resources :controls
    resources :categories
    put '/categories_in_place/:id' => 'categories#best_in_place_update'
    resources :products
    put '/products_in_place/:id' => 'products#best_in_place_update'
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
  resources :categories, only: [:index]
  resources :orders, only: [:index, :show]
  post '/checkout/pay_order_culqi_checkout', :to => 'checkout#pay_order_culqi_checkout'
  post '/checkout/pay_order_bank', :to => 'checkout#pay_order_bank'
  post '/orders/checkout/pay_order_culqi_checkout', :to => 'checkout#pay_order_culqi_checkout'
  post '/checkout/pay_order_manual', :to => 'checkout#pay_order_manual'
  get '/checkout', :to => 'checkout#show'
  get '/my_account', :to => 'users#show'

  post '/calculate_shipping', :to => 'integrations#get_shipping_quote'

  resources :carts, except: [:index, :new, :create]
  resources :cart_items
  resources :wishlists, except: [:index, :new, :create]
  resources :wishlist_items
  patch '/addresses/update_map', to: 'addresses#update_map'
  resources :addresses
  get '/categories_m', to: 'store#categories_mobile'
  get '/houses_m', to: 'store#houses_mobile'

  get '/ecommerce_root', to: 'store#main'
  root to: 'store#main'

end
