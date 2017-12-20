Ecommerce::Engine.routes.draw do

  namespace :backoffice do
    resources :products
    resources :product_variants
    resources :product_skus
    resources :product_sku_properties
  end
  
  root to: 'store#main'

end
