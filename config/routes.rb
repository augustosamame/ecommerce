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
    resources :provinces
    resources :orders
    post '/orders/einvoice'
    resources :payment_methods
    resources :payments, only: [:index]
    get '/translations/index', :to => "translations#index"
    resources :coupons
    get '/dynamic_coupon_index', :to => "coupons#dynamic_index"
    resources :combo_discounts
    resources :pricelists
    resources :product_prices
    put 'update_product_price', :to => "product_prices#bp_update", as: 'update_product_price'
    resources :campaigns
    get 'send_recipients/:id', :to => "campaigns#send_recipients", as: 'send_recipients'
    post 'send_recipients/:id', :to => "campaigns#post_send_recipients", as: 'post_send_recipients'
    get 'get_purchasers', :to => "campaigns#get_product_purchasers"
    get 'get_no_purchase_within_days', :to => "campaigns#get_no_purchase_within_days"
    get 'business_intelligence', :to => "dashboard#business_intelligence"
    post 'biz_top_buyers', :to => "dashboard#biz_top_buyers", as: 'post_biz_top_buyers'
    post 'biz_specific_product', :to => "dashboard#biz_specific_product", as: 'post_biz_specific_product'
    post 'biz_user_frequency', :to => "dashboard#biz_user_frequency", as: 'post_biz_user_frequency'
    post 'biz_product_frequency', :to => "dashboard#biz_product_frequency", as: 'post_biz_product_frequency'
    post 'biz_cross_selling', :to => "dashboard#biz_cross_selling", as: 'post_biz_cross_selling'
    post 'biz_cross_selling_open', :to => "dashboard#biz_cross_selling_open", as: 'post_biz_cross_selling_open'
    resources :audiences
    get 'audience_create_recipients/:id', :to => "audiences#create_recipients", as: 'audience_create_recipients'
    post 'audience_create_recipients/:id', :to => "audiences#post_create_recipients", as: 'audience_post_create_recipients'
    get 'audience_send_recipients/:id', :to => "audiences#send_recipients", as: 'audience_send_recipients'
    post 'audience_send_recipients/:id', :to => "audiences#post_send_recipients", as: 'audience_post_send_recipients'
    get 'audience_get_purchasers', :to => "audiences#get_product_purchasers"
    get 'audience_get_no_purchase_within_days', :to => "audiences#get_no_purchase_within_days"

    get "export_products" => "dashboard#export_products", as: :export_products
    get "export_users" => "dashboard#export_users", as: :export_users
    get "export_orders" => "dashboard#export_orders", as: :export_orders
    get "export_points" => "dashboard#export_points", as: :export_points
    get "user_points/:id" => "users#user_points", as: :user_points
    get "new_user_points/:id" => "users#new_user_points", as: :new_user_points
    post "points_transactions" => "users#create_user_points", as: :points_transactions
    get 'void_points_transaction/:id' => "users#void_points", as: :void_points_transaction
    get 'cross_selling' => "products#cross_selling"
    resources :stock_alerts
    resources :testimonials
  end

  post 'locale', :to => 'application#locale'
  #get '/category/:id', :to => 'store#shop_by_category', :as => 'category'
  #get '/product/:id', :to => 'store#product_detail', :as => 'product'
  resources :products, only: [:index, :show]
  resources :brands, only: [:show]
  get 'favorites', :to => 'products#favorites'
  resources :categories, only: [:index]
  resources :orders, only: [:index, :show]
  get '/points', :to => 'users#points_index'
  get '/referral', :to => 'users#referrals_index'
  get '/checkout/check_stock_cart_js_from_checkout', :to => 'checkout#check_stock_cart_js_from_checkout'
  post '/checkout/pay_order_culqi_checkout', :to => 'checkout#pay_order_culqi_checkout'
  post '/checkout/pay_order_culqi_checkout_3ds_step', :to => 'checkout#pay_order_culqi_checkout_3ds_step'
  post '/store/checkout/pay_order_culqi_checkout', :to => 'checkout#pay_order_culqi_checkout'
  post '/store/checkout/pay_order_culqi_checkout_3ds_step', :to => 'checkout#pay_order_culqi_checkout_3ds_step'
  post '/checkout/pay_order_pagoefectivo_checkout', :to => 'checkout#pay_order_pagoefectivo_checkout'
  post '/store/checkout/pay_order_pagoefectivo_checkout', :to => 'checkout#pay_order_pagoefectivo_checkout'
  post '/checkout/pay_order_bank', :to => 'checkout#pay_order_bank'
  post '/orders/checkout/pay_order_culqi_checkout', :to => 'checkout#pay_order_culqi_checkout'
  post '/orders/checkout/pay_order_culqi_checkout_3ds_step', :to => 'checkout#pay_order_culqi_checkout_3ds_step'
  post '/orders/checkout/pay_order_pagoefectivo_checkout', :to => 'checkout#pay_order_pagoefectivo_checkout'
  post '/checkout/pay_order_manual', :to => 'checkout#pay_order_manual'
  get '/checkout', :to => 'checkout#show'
  get '/pre_checkout', :to => 'checkout#pre_checkout'
  get '/my_account', :to => 'users#show'

  post '/calculate_shipping', :to => 'integrations#get_shipping_quote'
  post '/calculate_coupon', :to => 'orders#calculate_coupon'

  post '/culqi_webhook', :to => 'orders#culqi_webhook'

  resources :testimonials, only: [:index]
  resources :carts, except: [:index, :new, :create]
  resources :cart_items
  post 'stock_alerts', :to => 'products#stock_alert', as: 'stock_alerts'
  get 'search_product', :to => 'products#search', as: 'search_product'
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
