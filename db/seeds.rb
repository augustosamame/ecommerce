Ecommerce::Control.create(name: 'remove_no_stock_products', localized_name: 'Remove No Stock Products', value_field_type: "boolean", boolean_value: true)
Ecommerce::Control.create(name: 'invoice_terms_and_conditions', localized_name: 'Terms and Conditions for Invoices', value_field_type: "text", text_value: "No se aceptan cambios o devoluciones")
Ecommerce::Control.create(name: 'show_top_bar', localized_name: 'Show Top Bar', value_field_type: "boolean", boolean_value: true )
Ecommerce::Control.create(name: 'top_bar_cookie_read_hash', localized_name: 'Top Bar Cookie Read Hash', internal: true, value_field_type: "text")
Ecommerce::Control.create(name: 'top_bar_html', localized_name: 'Top Bar HTML', value_field_type: "text", text_value: "Back to the future of awesome Bags: Introducing the best bags in the world. <a href='#'>Shop Now</a>")
Ecommerce::Control.create(name: 'store_title', localized_name: 'Store Title', value_field_type: "text", text_value: "Put Store Title Here")
Ecommerce::Control.create(name: 'auto_invoice', localized_name: 'Auto Invoice', value_field_type: "boolean", boolean_value: false )
Ecommerce::Control.create(name: 'auto_ship', localized_name: 'Auto Ship', value_field_type: "boolean", boolean_value: false )


pm1 = Ecommerce::PaymentMethod.create(name: "Card", status: "active")
pm2 = Ecommerce::PaymentMethod.create(name: "Bank Deposit", status: "active")

b1 = Ecommerce::Brand.create(name: 'Organici', remote_logo_url: 'https://devtechperu-expatshop-dev.s3.amazonaws.com/uploads/ecommerce/brand/logo/2/organici_logo.png')
s1 = Ecommerce::Supplier.create(name: 'Organici')

c1 = Ecommerce::Category.create(name: "House of India", parent_id: nil, remote_image_url: "https://s3.amazonaws.com/devtechperu-expatshop-dev/static/images/home/house_of_india_2.jpg", image_popular_homepage_overlay_text: "House of India", status: "active", category_type: "secondary", category_order: 1, main_menu: true, popular: false, popular_homepage: true, image_popular_homepage: "https://s3.amazonaws.com/devtechperu-expatshop-dev/static/images/home/house_of_india_2.jpg", homepage_cat_image_width: 400, homepage_cat_image_height: 233)
c2 = Ecommerce::Category.create(name: "House of Arab", parent_id: nil, remote_image_url: "https://s3.amazonaws.com/devtechperu-expatshop-dev/static/images/home/house_of_arab.jpeg", image_popular_homepage_overlay_text: "House of Arab", status: "active", category_type: "secondary", category_order: 2, main_menu: true, popular: false, popular_homepage: true, image_popular_homepage: "https://s3.amazonaws.com/devtechperu-expatshop-dev/static/images/home/house_of_arab.jpeg", homepage_cat_image_width: 400, homepage_cat_image_height: 233)
c3 = Ecommerce::Category.create(name: "House of Canada", parent_id: nil, remote_image_url: "https://s3.amazonaws.com/devtechperu-expatshop-dev/static/images/home/house_of_canada.jpg", image_popular_homepage_overlay_text: "House of Canada", status: "active", category_type: "secondary", category_order: 3, main_menu: true, popular: false, popular_homepage: true, image_popular_homepage: "https://s3.amazonaws.com/devtechperu-expatshop-dev/static/images/home/house_of_canada.jpg", homepage_cat_image_width: 400, homepage_cat_image_height: 233)
c4 = Ecommerce::Category.create(name: "House of Peru", parent_id: nil, remote_image_url: "https://s3.amazonaws.com/devtechperu-expatshop-dev/static/images/home/house_of_peru.jpg", image_popular_homepage_overlay_text: "House of Peru", status: "active", category_type: "secondary", category_order: 4, main_menu: true, popular: false, popular_homepage: true, image_popular_homepage: "https://s3.amazonaws.com/devtechperu-expatshop-dev/static/images/home/house_of_peru.jpg", homepage_cat_image_width: 400, homepage_cat_image_height: 233)
c5 = Ecommerce::Category.create(name: "Food", parent_id: nil, status: "active", category_type: "primary", category_order: 0, main_menu: true, popular: false)
c6 = Ecommerce::Category.create(name: "Household", parent_id: nil, status: "active", category_type: "primary", category_order: 1, main_menu: true, popular: false)
c6 = Ecommerce::Category.create(name: "Baby Products", parent_id: nil, status: "active", category_type: "primary", category_order: 2, main_menu: true, popular: false)

Ecommerce::Product.create( category_list: "#{c1.name}, #{c5.name}", brand_id: b1.id, supplier_id: s1.id, name: "Indian Apples", description: "The best apples your hard earned money can buy", remote_image_url: "https://devtechperu-expatshop-dev.s3.amazonaws.com/uploads/ecommerce/product/image/1/apples.jpg", permalink: "Indian Apples", price_cents: 3000, discounted_price_cents: 3000, meta_keywords: nil, meta_description: nil, stockable: true, home_featured: false, category_featured: false, available_at: nil)
Ecommerce::Product.create( category_list: "#{c1.name}, #{c5.name}", brand_id: b1.id, supplier_id: s1.id, name: "Indian Rice", description: "The best rice your hard earned money can buy", remote_image_url: "https://devtechperu-expatshop-dev.s3.amazonaws.com/uploads/ecommerce/product/image/rice.jpeg", permalink: "Indian Rice", price_cents: 2000, discounted_price_cents: 2000, meta_keywords: nil, meta_description: nil, stockable: true, home_featured: false, category_featured: false, available_at: nil)
Ecommerce::Product.create( category_list: "#{c2.name}, #{c5.name}", brand_id: b1.id, supplier_id: s1.id, name: "Arabian Dates", description: "The best dates your hard earned money can buy", remote_image_url: "https://devtechperu-expatshop-dev.s3.amazonaws.com/uploads/ecommerce/product/image/arabian_dates.png", permalink: "permalink3", price_cents: 10000, discounted_price_cents: 5000, meta_keywords: nil, meta_description: nil, stockable: true, home_featured: false, category_featured: false, available_at: nil)
Ecommerce::Product.create( category_list: "#{c2.name}, #{c5.name}", brand_id: b1.id, supplier_id: s1.id, name: "Arabian Cotton Blankets", description: "The best blankets your hard earned money can buy", remote_image_url: "https://devtechperu-expatshop-dev.s3.amazonaws.com/uploads/ecommerce/product/image/arabian_cotton_blankets.jpg", permalink: "permalink4", price_cents: 3000, discounted_price_cents: 3000, meta_keywords: nil, meta_description: nil, stockable: true, home_featured: false, category_featured: false, available_at: nil)
Ecommerce::Product.create( category_list: "#{c3.name}, #{c5.name}", brand_id: b1.id, supplier_id: s1.id, name: "Canadian Wine", description: "The best wine your hard earned money can buy", remote_image_url: "https://devtechperu-expatshop-dev.s3.amazonaws.com/uploads/ecommerce/product/image/canadian_wine.jpg", permalink: "permalink5", price_cents: 7000, discounted_price_cents: 7000, meta_keywords: nil, meta_description: nil, stockable: true, home_featured: false, category_featured: false, available_at: nil)
Ecommerce::Product.create( category_list: "#{c3.name}, #{c5.name}", brand_id: b1.id, supplier_id: s1.id, name: "Canadian Cheese", description: "The best cheese your hard earned money can buy", remote_image_url: "https://devtechperu-expatshop-dev.s3.amazonaws.com/uploads/ecommerce/product/image/canadian_cheese.jpg", permalink: "permalink6", price_cents: 8000, discounted_price_cents: 8000, meta_keywords: nil, meta_description: nil, stockable: true, home_featured: false, category_featured: false, available_at: nil)
Ecommerce::Product.create( category_list: "#{c4.name}, #{c6.name}", brand_id: b1.id, supplier_id: s1.id, name: "Alpaca Coats", description: "The best coats your hard earned money can buy", remote_image_url: "https://devtechperu-expatshop-dev.s3.amazonaws.com/uploads/ecommerce/product/image/alpaca_coats.png", permalink: "permalink7", price_cents: 40000, discounted_price_cents: 20000, meta_keywords: nil, meta_description: nil, stockable: true, home_featured: false, category_featured: false, available_at: nil)
Ecommerce::Product.create( category_list: "#{c4.name}, #{c5.name}", brand_id: b1.id, supplier_id: s1.id, name: "Pisco Queirolo", description: "The best pisco your hard earned money can buy", remote_image_url: "https://devtechperu-expatshop-dev.s3.amazonaws.com/uploads/ecommerce/product/image/pisco_queirolo.jpg", permalink: "permalink8", price_cents: 3000, discounted_price_cents: 3000, meta_keywords: nil, meta_description: nil, stockable: true, home_featured: false, category_featured: false, available_at: nil)
