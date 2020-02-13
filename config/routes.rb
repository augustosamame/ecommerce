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
    put '/translations/category_translations_in_place/:id' => 'categories#best_in_place_translation_update'
    resources :products
    put '/products_in_place/:id' => 'products#best_in_place_update'
    put '/translations/product_translations_in_place/:id' => 'products#best_in_place_translation_update'
    resources :product_variants
    resources :product_skus
    resources :product_sku_properties
    resources :properties
    resources :addresses
    resources :orders
    post '/orders/einvoice'
    resources :payment_methods
    get '/translations/index', :to => "translations#index"
    resources :coupons
    get '/dynamic_coupon_index', :to => "coupons#dynamic_index"
    resources :pricelists
    resources :product_prices
    put 'update_product_price', :to => "product_prices#bp_update", as: 'update_product_price'
    resources :campaigns
    get 'send_recipients/:id', :to => "campaigns#send_recipients", as: 'send_recipients'
    post 'send_recipients/:id', :to => "campaigns#post_send_recipients", as: 'post_send_recipients'
    get 'get_purchasers', :to => "campaigns#get_product_purchasers"
    get 'get_no_purchase_within_days', :to => "campaigns#get_no_purchase_within_days"
    get "export_products" => "dashboard#export_products", as: :export_products
    get "export_users" => "dashboard#export_users", as: :export_users
  end

  post 'locale', :to => 'application#locale'
  #get '/category/:id', :to => 'store#shop_by_category', :as => 'category'
  #get '/product/:id', :to => 'store#product_detail', :as => 'product'
  resources :products, only: [:index, :show]
  get 'favorites', :to => 'products#favorites'
  resources :categories, only: [:index]
  resources :orders, only: [:index, :show]
  post '/checkout/pay_order_culqi_checkout', :to => 'checkout#pay_order_culqi_checkout'
  post '/store/checkout/pay_order_culqi_checkout', :to => 'checkout#pay_order_culqi_checkout'
  post '/checkout/pay_order_pagoefectivo_checkout', :to => 'checkout#pay_order_pagoefectivo_checkout'
  post '/store/checkout/pay_order_pagoefectivo_checkout', :to => 'checkout#pay_order_pagoefectivo_checkout'
  post '/checkout/pay_order_bank', :to => 'checkout#pay_order_bank'
  post '/orders/checkout/pay_order_culqi_checkout', :to => 'checkout#pay_order_culqi_checkout'
  post '/orders/checkout/pay_order_pagoefectivo_checkout', :to => 'checkout#pay_order_pagoefectivo_checkout'
  post '/checkout/pay_order_manual', :to => 'checkout#pay_order_manual'
  get '/checkout', :to => 'checkout#show'
  get '/my_account', :to => 'users#show'

  post '/calculate_shipping', :to => 'integrations#get_shipping_quote'
  post '/calculate_coupon', :to => 'orders#calculate_coupon'

  post '/culqi_webhook', :to => 'orders#culqi_webhook'

  resources :carts, except: [:index, :new, :create]
  resources :cart_items
  resources :wishlists, except: [:index, :new, :create]
  resources :wishlist_items
  patch '/addresses/update_map', to: 'addresses#update_map'
  resources :addresses
  get '/categories_m', to: 'store#categories_mobile'
  get '/sub_categories_m', to: 'store#sub_categories_mobile'
  get '/houses_m', to: 'store#houses_mobile'
  get '/about_us', to: 'store#about_us'
  get '/shipping_policy', to: 'store#shipping_policy'
  get '/terms_and_conditions', to: 'store#terms_and_conditions'
  get '/contact_us', to: 'store#contact_us'
  post '/contact_us', to: 'store#post_contact_us'
  get '/wishlist_message', to: 'store#wishlist'
  post '/wishlist_message', to: 'store#post_wishlist'
  get '/ecommerce_root', to: 'store#main'
  root to: 'store#main'

end
