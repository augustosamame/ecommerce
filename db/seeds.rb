Ecommerce::Control.create(name: 'remove_no_stock_products', localized_name: 'Remove No Stock Products', value_field_type: "boolean", boolean_value: true)
Ecommerce::Control.create(name: 'invoice_terms_and_conditions', localized_name: 'Terms and Conditions for Invoices', value_field_type: "text", text_value: "No se aceptan cambios o devoluciones")
Ecommerce::Control.create(name: 'show_top_bar', localized_name: 'Show Top Bar', value_field_type: "boolean", boolean_value: true )
Ecommerce::Control.create(name: 'top_bar_cookie_read_hash', localized_name: 'Top Bar Cookie Read Hash', internal: true, value_field_type: "text")
Ecommerce::Control.create(name: 'top_bar_html', localized_name: 'Top Bar HTML', value_field_type: "text", text_value: "Back to the future of awesome Bags: Introducing the best bags in the world. <a href='#'>Shop Now</a>")
Ecommerce::Control.create(name: 'store_title', localized_name: 'Store Title', value_field_type: "text", text_value: "Put Store Title Here")
Ecommerce::Control.create(name: 'auto_invoice', localized_name: 'Auto Invoice', value_field_type: "boolean", boolean_value: false )
Ecommerce::Control.create(name: 'auto_ship', localized_name: 'Auto Ship', value_field_type: "boolean", boolean_value: false )
Ecommerce::Control.create(name: 'home_slider1_text', localized_name: 'Home Slider 1 Text', value_field_type: "text", text_value: "Put Home Slider 1 Text Here" )
Ecommerce::Control.create(name: 'home_slider_image1', localized_name: 'Home Slider 1st Image', value_field_type: "text", text_value: "https://s3.amazonaws.com/devtechperu-expatshop-dev/static/images/home/Sliders/marinmeko+slider.jpg" )
Ecommerce::Control.create(name: 'home_slider2_text', localized_name: 'Home Slider 2 Text', value_field_type: "text", text_value: "Put Home Slider 2 Text Here" )
Ecommerce::Control.create(name: 'home_slider_image2', localized_name: 'Home Slider 2nd Image', value_field_type: "text", text_value: "https://s3.amazonaws.com/devtechperu-expatshop-dev/static/images/home/Sliders/babyganics.jpg" )
Ecommerce::Control.create(name: 'home_slider3_text', localized_name: 'Home Slider 3 Text', value_field_type: "text", text_value: "Put Home Slider 3 Text Here" )
Ecommerce::Control.create(name: 'home_slider_image3', localized_name: 'Home Slider 3rd Image', value_field_type: "text", text_value: "https://s3.amazonaws.com/devtechperu-expatshop-dev/static/images/home/Sliders/slider_image3.png" )
Ecommerce::Control.create(name: 'home_slider4_text', localized_name: 'Home Slider 4 Text', value_field_type: "text", text_value: "Put Home Slider 4 Text Here" )
Ecommerce::Control.create(name: 'home_slider_image4', localized_name: 'Home Slider 4th Image', value_field_type: "text", text_value: "https://s3.amazonaws.com/devtechperu-expatshop-dev/static/images/home/Sliders/slider_image3.png" )
Ecommerce::Control.create(name: 'home_slider5_text', localized_name: 'Home Slider 5 Text', value_field_type: "text", text_value: "Put Home Slider 5 Text Here" )
Ecommerce::Control.create(name: 'home_slider_image5', localized_name: 'Home Slider 5th Image', value_field_type: "text", text_value: "https://s3.amazonaws.com/devtechperu-expatshop-dev/static/images/home/Sliders/slider_image3.png" )

pm1 = Ecommerce::PaymentMethod.create(name: "Card", status: "active")
pm2 = Ecommerce::PaymentMethod.create(name: "Bank Deposit", status: "active")

if Rails.env.development?

  b1 = Ecommerce::Brand.create(name: 'Dr. Brown', remote_logo_url: 'https://devtechperu-expatshop-dev.s3.amazonaws.com/uploads/ecommerce/brand/logo/2/organici_logo.png', featured: true)
  b2 = Ecommerce::Brand.create(name: 'Babyganics', remote_logo_url: 'https://devtechperu-expatshop-dev.s3.amazonaws.com/uploads/ecommerce/brand/logo/2/organici_logo.png', featured: true)
  b3 = Ecommerce::Brand.create(name: 'Mr Clean', remote_logo_url: 'https://devtechperu-expatshop-dev.s3.amazonaws.com/uploads/ecommerce/brand/logo/2/organici_logo.png', featured: true)
  b4 = Ecommerce::Brand.create(name: 'Czech Crystal', remote_logo_url: 'https://devtechperu-expatshop-dev.s3.amazonaws.com/uploads/ecommerce/brand/logo/2/organici_logo.png', featured: false)
  s1 = Ecommerce::Supplier.create(name: 'Importer Name')

  c1 = Ecommerce::Category.create(name: "House of Canada", parent_id: nil, remote_image_url: "https://s3.amazonaws.com/devtechperu-expatshop-dev/static/images/home/house_of_canada.png", image_popular_homepage_overlay_text: "House of Canada", status: "active", category_type: "secondary", category_order: 0, main_menu: true, popular: false, popular_homepage: true, image_popular_homepage: "https://s3.amazonaws.com/devtechperu-expatshop-dev/static/images/home/house_of_canada.png", homepage_cat_image_width: 400, homepage_cat_image_height: 233)
  c2 = Ecommerce::Category.create(name: "House of USA", parent_id: nil, remote_image_url: "https://s3.amazonaws.com/devtechperu-expatshop-dev/static/images/home/house_of_usa.png", image_popular_homepage_overlay_text: "House of USA", status: "active", category_type: "secondary", category_order: 1, main_menu: true, popular: false, popular_homepage: true, image_popular_homepage: "https://s3.amazonaws.com/devtechperu-expatshop-dev/static/images/home/house_of_usa.png", homepage_cat_image_width: 400, homepage_cat_image_height: 233)
  c3 = Ecommerce::Category.create(name: "House of England", parent_id: nil, remote_image_url: "https://s3.amazonaws.com/devtechperu-expatshop-dev/static/images/home/house_of_england.png", image_popular_homepage_overlay_text: "House of England", status: "active", category_type: "secondary", category_order: 2, main_menu: true, popular: false, popular_homepage: true, image_popular_homepage: "https://s3.amazonaws.com/devtechperu-expatshop-dev/static/images/home/house_of_canada.jpg", homepage_cat_image_width: 400, homepage_cat_image_height: 233)
  c4 = Ecommerce::Category.create(name: "House of France", parent_id: nil, remote_image_url: "https://s3.amazonaws.com/devtechperu-expatshop-dev/static/images/home/house_of_france.png", image_popular_homepage_overlay_text: "House of France", status: "active", category_type: "secondary", category_order: 3, main_menu: true, popular: false, popular_homepage: true, image_popular_homepage: "https://s3.amazonaws.com/devtechperu-expatshop-dev/static/images/home/house_of_canada.jpg", homepage_cat_image_width: 400, homepage_cat_image_height: 233)
  #c5 = Ecommerce::Category.create(name: "House of Switzerland", parent_id: nil, remote_image_url: "https://s3.amazonaws.com/devtechperu-expatshop-dev/static/images/home/house_of_canada.jpg", image_popular_homepage_overlay_text: "House of Switzerland", status: "active", category_type: "secondary", category_order: 4, main_menu: true, popular: false, popular_homepage: true, image_popular_homepage: "https://s3.amazonaws.com/devtechperu-expatshop-dev/static/images/home/house_of_canada.jpg", homepage_cat_image_width: 400, homepage_cat_image_height: 233)
  #c6 = Ecommerce::Category.create(name: "House of Belgium", parent_id: nil, remote_image_url: "https://s3.amazonaws.com/devtechperu-expatshop-dev/static/images/home/house_of_canada.jpg", image_popular_homepage_overlay_text: "House of Belgium", status: "active", category_type: "secondary", category_order: 5, main_menu: true, popular: false, popular_homepage: true, image_popular_homepage: "https://s3.amazonaws.com/devtechperu-expatshop-dev/static/images/home/house_of_canada.jpg", homepage_cat_image_width: 400, homepage_cat_image_height: 233)
  #c7 = Ecommerce::Category.create(name: "House of Czech Republic", parent_id: nil, remote_image_url: "https://s3.amazonaws.com/devtechperu-expatshop-dev/static/images/home/house_of_czech_republic.png", image_popular_homepage_overlay_text: "House of Czech Republic", status: "active", category_type: "secondary", category_order: 6, main_menu: true, popular: false, popular_homepage: true, image_popular_homepage: "https://s3.amazonaws.com/devtechperu-expatshop-dev/static/images/home/house_of_canada.jpg", homepage_cat_image_width: 400, homepage_cat_image_height: 233)
  #c8 = Ecommerce::Category.create(name: "House of Italy", parent_id: nil, remote_image_url: "https://s3.amazonaws.com/devtechperu-expatshop-dev/static/images/home/house_of_italy.png", image_popular_homepage_overlay_text: "House of Italy", status: "active", category_type: "secondary", category_order: 7, main_menu: true, popular: false, popular_homepage: true, image_popular_homepage: "https://s3.amazonaws.com/devtechperu-expatshop-dev/static/images/home/house_of_canada.jpg", homepage_cat_image_width: 400, homepage_cat_image_height: 233)
  #c9 = Ecommerce::Category.create(name: "House of Austria", parent_id: nil, remote_image_url: "https://s3.amazonaws.com/devtechperu-expatshop-dev/static/images/home/house_of_india_2.jpg", image_popular_homepage_overlay_text: "House of Austria", status: "active", category_type: "secondary", category_order: 8, main_menu: true, popular: false, popular_homepage: true, image_popular_homepage: "https://s3.amazonaws.com/devtechperu-expatshop-dev/static/images/home/house_of_india_2.jpg", homepage_cat_image_width: 400, homepage_cat_image_height: 233)
  #c10 = Ecommerce::Category.create(name: "House of Finland", parent_id: nil, remote_image_url: "https://s3.amazonaws.com/devtechperu-expatshop-dev/static/images/home/house_of_arab.jpeg", image_popular_homepage_overlay_text: "House of Finland", status: "active", category_type: "secondary", category_order: 9, main_menu: true, popular: false, popular_homepage: true, image_popular_homepage: "https://s3.amazonaws.com/devtechperu-expatshop-dev/static/images/home/house_of_arab.jpeg", homepage_cat_image_width: 400, homepage_cat_image_height: 233)
  #c11 = Ecommerce::Category.create(name: "House of Sweden", parent_id: nil, remote_image_url: "https://s3.amazonaws.com/devtechperu-expatshop-dev/static/images/home/house_of_arab.jpeg", image_popular_homepage_overlay_text: "House of Sweden", status: "active", category_type: "secondary", category_order: 10, main_menu: true, popular: false, popular_homepage: true, image_popular_homepage: "https://s3.amazonaws.com/devtechperu-expatshop-dev/static/images/home/house_of_arab.jpeg", homepage_cat_image_width: 400, homepage_cat_image_height: 233)
  #c12 = Ecommerce::Category.create(name: "House of Greece", parent_id: nil, remote_image_url: "https://s3.amazonaws.com/devtechperu-expatshop-dev/static/images/home/house_of_arab.jpeg", image_popular_homepage_overlay_text: "House of Greece", status: "active", category_type: "secondary", category_order: 11, main_menu: true, popular: false, popular_homepage: true, image_popular_homepage: "https://s3.amazonaws.com/devtechperu-expatshop-dev/static/images/home/house_of_arab.jpeg", homepage_cat_image_width: 400, homepage_cat_image_height: 233)
  #c13 = Ecommerce::Category.create(name: "House of Hungary", parent_id: nil, remote_image_url: "https://s3.amazonaws.com/devtechperu-expatshop-dev/static/images/home/house_of_arab.jpeg", image_popular_homepage_overlay_text: "House of Hungary", status: "active", category_type: "secondary", category_order: 12, main_menu: true, popular: false, popular_homepage: true, image_popular_homepage: "https://s3.amazonaws.com/devtechperu-expatshop-dev/static/images/home/house_of_arab.jpeg", homepage_cat_image_width: 400, homepage_cat_image_height: 233)
  #c14 = Ecommerce::Category.create(name: "House of Romania", parent_id: nil, remote_image_url: "https://s3.amazonaws.com/devtechperu-expatshop-dev/static/images/home/house_of_arab.jpeg", image_popular_homepage_overlay_text: "House of Romania", status: "active", category_type: "secondary", category_order: 13, main_menu: true, popular: false, popular_homepage: true, image_popular_homepage: "https://s3.amazonaws.com/devtechperu-expatshop-dev/static/images/home/house_of_arab.jpeg", homepage_cat_image_width: 400, homepage_cat_image_height: 233)
  #c15 = Ecommerce::Category.create(name: "House of Russia", parent_id: nil, remote_image_url: "https://s3.amazonaws.com/devtechperu-expatshop-dev/static/images/home/house_of_arab.jpeg", image_popular_homepage_overlay_text: "House of Russia", status: "active", category_type: "secondary", category_order: 14, main_menu: true, popular: false, popular_homepage: true, image_popular_homepage: "https://s3.amazonaws.com/devtechperu-expatshop-dev/static/images/home/house_of_arab.jpeg", homepage_cat_image_width: 400, homepage_cat_image_height: 233)
  #c16 = Ecommerce::Category.create(name: "House of Netherlands", parent_id: nil, remote_image_url: "https://s3.amazonaws.com/devtechperu-expatshop-dev/static/images/home/house_of_arab.jpeg", image_popular_homepage_overlay_text: "House of Netherlands", status: "active", category_type: "secondary", category_order: 15, main_menu: true, popular: false, popular_homepage: true, image_popular_homepage: "https://s3.amazonaws.com/devtechperu-expatshop-dev/static/images/home/house_of_arab.jpeg", homepage_cat_image_width: 400, homepage_cat_image_height: 233)
  #c17 = Ecommerce::Category.create(name: "House of Arab", parent_id: nil, remote_image_url: "https://s3.amazonaws.com/devtechperu-expatshop-dev/static/images/home/house_of_arab.png", image_popular_homepage_overlay_text: "House of Arab", status: "active", category_type: "secondary", category_order: 16, main_menu: true, popular: false, popular_homepage: true, image_popular_homepage: "https://s3.amazonaws.com/devtechperu-expatshop-dev/static/images/home/house_of_arab.jpeg", homepage_cat_image_width: 400, homepage_cat_image_height: 233)
  #c18 = Ecommerce::Category.create(name: "House of India", parent_id: nil, remote_image_url: "https://s3.amazonaws.com/devtechperu-expatshop-dev/static/images/home/house_of_india.png", image_popular_homepage_overlay_text: "House of India", status: "active", category_type: "secondary", category_order: 17, main_menu: true, popular: false, popular_homepage: true, image_popular_homepage: "https://s3.amazonaws.com/devtechperu-expatshop-dev/static/images/home/house_of_arab.jpeg", homepage_cat_image_width: 400, homepage_cat_image_height: 233)
  #c19 = Ecommerce::Category.create(name: "House of Australia", parent_id: nil, remote_image_url: "https://s3.amazonaws.com/devtechperu-expatshop-dev/static/images/home/house_of_australia.png", image_popular_homepage_overlay_text: "House of Australia", status: "active", category_type: "secondary", category_order: 18, main_menu: true, popular: false, popular_homepage: true, image_popular_homepage: "https://s3.amazonaws.com/devtechperu-expatshop-dev/static/images/home/house_of_arab.jpeg", homepage_cat_image_width: 400, homepage_cat_image_height: 233)
  #c20 = Ecommerce::Category.create(name: "House of Israel", parent_id: nil, remote_image_url: "https://s3.amazonaws.com/devtechperu-expatshop-dev/static/images/home/house_of_israel.png", image_popular_homepage_overlay_text: "House of Israel", status: "active", category_type: "secondary", category_order: 19, main_menu: true, popular: false, popular_homepage: true, image_popular_homepage: "https://s3.amazonaws.com/devtechperu-expatshop-dev/static/images/home/house_of_arab.jpeg", homepage_cat_image_width: 400, homepage_cat_image_height: 233)
  #c21 = Ecommerce::Category.create(name: "South Korea", parent_id: nil, remote_image_url: "https://s3.amazonaws.com/devtechperu-expatshop-dev/static/images/home/house_of_arab.jpeg", image_popular_homepage_overlay_text: "House of South Korea", status: "active", category_type: "secondary", category_order: 20, main_menu: true, popular: false, popular_homepage: true, image_popular_homepage: "https://s3.amazonaws.com/devtechperu-expatshop-dev/static/images/home/house_of_arab.jpeg", homepage_cat_image_width: 400, homepage_cat_image_height: 233)

  c22 = Ecommerce::Category.create(name: "Baby Products", parent_id: nil, status: "active", category_type: "primary", category_order: 0, main_menu: true, popular: false)
  c23 = Ecommerce::Category.create(name: "Household", parent_id: nil, status: "active", category_type: "primary", category_order: 1, main_menu: true, popular: false)
  c24 = Ecommerce::Category.create(name: "Specialized Food", parent_id: nil, status: "active", category_type: "primary", category_order: 2, main_menu: true, popular: false)
  #c25 = Ecommerce::Category.create(name: "Ethnic Food", parent_id: nil, status: "active", category_type: "primary", category_order: 3, main_menu: true, popular: false)
  #c26 = Ecommerce::Category.create(name: "Cosmetics", parent_id: nil, status: "active", category_type: "primary", category_order: 4, main_menu: true, popular: false)

  Ecommerce::Product.create( category_list: "#{c2.name}, #{c23.name}", brand_id: b1.id, supplier_id: s1.id, name: "Bra Ball", short_description: "Bra Washer Protector Ball prevents winding among clothes.", description: "Design:a big hollow bra ball+a small clothes massage ball,just put underwear and small massage ball into big bra ball,then put it into washing machine,flower hollow design,fashion and launder bras without damage, protect bras from tangling and snagging. Safe alternative to hand washing,saving time,and washing cleaner.Keeps hooks from bending,cups keep their shape,bras last longer and look better. Suitable for all type of bras and bathing suits,also can be used as a suitcase travel bra protector.", description2: "El Bra Ball the permite introducir el bra en una bola de plástico que podrá lavase en la lavadora sin dañar el bra, ni el resto de la ropa en la lavadora. Una segura alternativa a lavar a mano, ahorrando tiempo y obteniendo un mejor lavado.", remote_image_url: "https://s3.amazonaws.com/devtechperu-expatshop-dev/static/images/home/Products/bra_ball.jpg", permalink: "Bra Ball", price_cents: 3000, discounted_price_cents: 3000, meta_keywords: nil, meta_description: nil, stockable: true, home_featured: true, category_featured: false, available_at: nil)
  Ecommerce::Product.create( category_list: "#{c1.name}, #{c23.name}", brand_id: b1.id, supplier_id: s1.id, name: "Mr Clean Magic Eraser", short_description: "Powerful Multi Purpose Cleaning with Water Alone", description: "Water Activated Microscrubbers lift and remove dirt around your home. Great for multi purpose cleaning on car windshield glass, leather athletic shoes, walls, doors, baseboards, glass table tops and more!", description2: "Limpiadores Microscópicos Activados por el agua que levantan y limpian la suciedad alrededor de tu casa. Perfectos para limpieza multiusos como limpieza de vidrios de autos, zapatos de cuero, paredes, puertas, mesas de vidrio y mas!", remote_image_url: "https://s3.amazonaws.com/devtechperu-expatshop-dev/static/images/home/Products/mr_clean_magic-eraser.jpg", permalink: "Indian Rice", price_cents: 2000, discounted_price_cents: 2000, meta_keywords: nil, meta_description: nil, stockable: true, home_featured: true, category_featured: false, available_at: nil)
  Ecommerce::Product.create( category_list: "#{c2.name}, #{c23.name}", brand_id: b1.id, supplier_id: s1.id, name: "Dr. Brown Sippy Spouts", short_description: "Soft, 100% silicone spout is gentle on little mouths", description: "Dr. Brown's Options Sippy Spout is easy for baby to use and offers your little one the best and easiest transition from bottle to cup. This easy to sip, spill-proof sippy spout replaces the bottle nipple and vent", remote_image_url: "https://s3.amazonaws.com/devtechperu-expatshop-dev/static/images/home/Products/dr_brown_sippy_spout.jpg", permalink: "permalink3", price_cents: 10000, discounted_price_cents: 5000, meta_keywords: nil, meta_description: nil, stockable: true, home_featured: true, category_featured: false, available_at: nil)
  Ecommerce::Product.create( category_list: "#{c2.name}, #{c23.name}", brand_id: b1.id, supplier_id: s1.id, name: "Bohemian Czech Crystal", short_description: "Exquisite, exclusive designs from Czech Republic", description: "Bohemia crystal is glass produced in the regions of Bohemia and Silesia, now parts of the Czech Republic. It has a centuries long history of being internationally recognised for its high quality, craftsmanship, beauty and often innovative designs", remote_image_url: "https://s3.amazonaws.com/devtechperu-expatshop-dev/static/images/home/Products/bohemian_crystal.JPG", permalink: "permalink4", price_cents: 3000, discounted_price_cents: 3000, meta_keywords: nil, meta_description: nil, stockable: true, home_featured: true, category_featured: false, available_at: nil)
  Ecommerce::Product.create( category_list: "#{c3.name}, #{c23.name}", brand_id: b1.id, supplier_id: s1.id, name: "EZPC Mat", short_description: "All-in-one placemat and plate", description: "Placemat suctions to any flat surface to reduce tipped bowls / plates. Smiley face design puts kids in the right mood for a positive mealtime experience Promotes self-feeding and develops fine motor skills", remote_image_url: "https://s3.amazonaws.com/devtechperu-expatshop-dev/static/images/home/Products/ezpc_mat.jpg", permalink: "permalink5", price_cents: 7000, discounted_price_cents: 7000, meta_keywords: nil, meta_description: nil, stockable: true, home_featured: true, category_featured: false, available_at: nil)
  #Ecommerce::Product.create( category_list: "#{c3.name}, #{c23.name}", brand_id: b1.id, supplier_id: s1.id, name: "Canadian Cheese", short_description: "The best cheese your hard earned money can buy", description: "The best cheese your hard earned money can buy", remote_image_url: "https://devtechperu-expatshop-dev.s3.amazonaws.com/uploads/ecommerce/product/image/canadian_cheese.jpg", permalink: "permalink6", price_cents: 8000, discounted_price_cents: 8000, meta_keywords: nil, meta_description: nil, stockable: true, home_featured: true, category_featured: false, available_at: nil)
  #Ecommerce::Product.create( category_list: "#{c4.name}, #{c23.name}", brand_id: b1.id, supplier_id: s1.id, name: "Alpaca Coats", short_description: "The best coats your hard earned money can buy", description: "The best coats your hard earned money can buy", remote_image_url: "https://devtechperu-expatshop-dev.s3.amazonaws.com/uploads/ecommerce/product/image/alpaca_coats.png", permalink: "permalink7", price_cents: 40000, discounted_price_cents: 20000, meta_keywords: nil, meta_description: nil, stockable: true, home_featured: true, category_featured: false, available_at: nil)

end
