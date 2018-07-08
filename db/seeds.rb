# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
#u1 = User.create(first_name: 'Augusto', last_name: "Samame", username: "986976377", email: "augustosamame@gmail.com", password: "marianna", role: "admin", status: 0)
#u2 = User.create(first_name: 'Arnaldo', last_name: "Azabache", username: "993306393", email: "oxxono@gmail.com", password: "123456", role: "admin", status: 0)
#u3 = User.create(first_name: 'Hemant', last_name: "Nangia", username: "989080023", email: "hemant@expatshop.pe", password: "123456", role: "admin", status: 0)
#Ecommerce::Control.create(name: 'remove_no_stock_products', localized_name: 'Remove No Stock Products', value_field_type: "boolean", boolean_value: true)
#Ecommerce::Control.create(name: 'invoice_terms_and_conditions', localized_name: 'Terms and Conditions for Invoices', value_field_type: "text", text_value: "No se aceptan cambios o devoluciones")
#Ecommerce::Control.create(name: 'show_top_bar', localized_name: 'Show Top Bar', value_field_type: "boolean", boolean_value: true )
#Ecommerce::Control.create(name: 'top_bar_cookie_read_hash', localized_name: 'Top Bar Cookie Read Hash', internal: true, value_field_type: "text")
#Ecommerce::Control.create(name: 'top_bar_html', localized_name: 'Top Bar HTML', value_field_type: "text", text_value: "Back to the future of awesome Bags: Introducing the best bags in the world. <a href='#'>Shop Now</a>")
#Ecommerce::Control.create(name: 'store_title', localized_name: 'Store Title', value_field_type: "text", text_value: "Put Store Title Here")
#Ecommerce::Control.create(name: 'auto_invoice', localized_name: 'Auto Invoice', value_field_type: "boolean", boolean_value: false )
#Ecommerce::Control.create(name: 'auto_ship', localized_name: 'Auto Ship', value_field_type: "boolean", boolean_value: false )

#Ecommerce::Slider.create(slider_name: 'Home Slider 1', slider_text: "", remote_slider_image_url: "https://s3.amazonaws.com/devtechperu-expatshop-dev/static/images/home/Sliders/marinmeko+slider.jpg", slider_view: "Home", slider_order: 1 )
#Ecommerce::Slider.create(slider_name: 'Home Slider 2', slider_text: "", remote_slider_image_url: "https://s3.amazonaws.com/devtechperu-expatshop-dev/static/images/home/Sliders/babyganics.jpg", slider_view: "Home", slider_order: 2 )
#Ecommerce::Slider.create(slider_name: 'Home Slider 3', slider_text: "", remote_slider_image_url: "https://s3.amazonaws.com/devtechperu-expatshop-dev/static/images/home/Sliders/slider_image3.png", slider_view: "Home", slider_order: 3 )
#Ecommerce::Slider.create(slider_name: 'Home Slider 4', slider_text: "", remote_slider_image_url: "https://s3.amazonaws.com/devtechperu-expatshop-dev/static/images/home/Sliders/slider_image3.pngg", slider_view: "Home", slider_order: 4 )
#Ecommerce::Slider.create(slider_name: 'Home Slider 5', slider_text: "", remote_slider_image_url: "https://s3.amazonaws.com/devtechperu-expatshop-dev/static/images/home/Sliders/slider_image3.png", slider_view: "Home", slider_order: 5 )

#pm1 = Ecommerce::PaymentMethod.create(name: "Card", processor: "Culqi", status: "active")
#pm2 = Ecommerce::PaymentMethod.create(name: "Bank Deposit", status: "active")
#pm3 = Ecommerce::PaymentMethod.create(name: "Manual", status: "active")

=begin
Ecommerce::Brand.create!([
  {name: "Dr. Brown", logo: "organici_logo.png"},
  {name: "Babyganics", logo: "organici_logo.png"},
  {name: "Mr Clean", logo: "organici_logo.png"},
  {name: "Czech Crystal", logo: "organici_logo.png"},
  {name: "Amar Te", logo: "Logo.jpg"},
  {name: "IHR", logo: nil}
])
Ecommerce::Supplier.create!([
  {name: "Importer Name", logo: nil, tax_id: nil, tax_id_type: nil, default_hours_lead_time: nil},
  {name: "Andrea Kovacs", logo: "Amar Te", tax_id: "20603295855", tax_id_type: nil, default_hours_lead_time: nil},
  {name: "IHR", logo: "IHR", tax_id: "", tax_id_type: nil, default_hours_lead_time: nil}
])
Ecommerce::Category.create!([
  {name: "House of India", parent_id: nil, remote_image_url: "https://devtechperu-expatshop-dev.s3.amazonaws.com/uploads/ecommerce/category/image/8/house_of_india.png", status: "active", category_type: "secondary", category_order: 17, main_menu: true, popular: false, popular_homepage: true, image_popular_homepage: nil, image_popular_homepage_overlay_text: "House of India", homepage_cat_image_width: "400.0", homepage_cat_image_height: "233.0"},
  {name: "Disposable Table Runners", parent_id: 16, remote_image_url: "https://devtechperu-expatshop-dev.s3.amazonaws.com/uploads/ecommerce/category/image/23/Table_Runners.jpg", status: "active", category_type: "primary", category_order: 7, main_menu: true, popular: false, popular_homepage: false, image_popular_homepage: nil, image_popular_homepage_overlay_text: "Disposable Table Runners", homepage_cat_image_width: nil, homepage_cat_image_height: nil},
  {name: "Cocktail Napkins", parent_id: 16, remote_image_url: "https://devtechperu-expatshop-dev.s3.amazonaws.com/uploads/ecommerce/category/image/18/Coctail_Napkin_hip.jpg", status: "active", category_type: "primary", category_order: 0, main_menu: true, popular: false, popular_homepage: false, image_popular_homepage: nil, image_popular_homepage_overlay_text: "Cocktail Napkins", homepage_cat_image_width: nil, homepage_cat_image_height: nil},
  {name: "Large Napkins", parent_id: 16, remote_image_url: "https://devtechperu-expatshop-dev.s3.amazonaws.com/uploads/ecommerce/category/image/20/Large_Napkin.jpg", status: "active", category_type: "primary", category_order: 1, main_menu: true, popular: false, popular_homepage: false, image_popular_homepage: nil, image_popular_homepage_overlay_text: "Large Napkins", homepage_cat_image_width: nil, homepage_cat_image_height: nil},
  {name: "Organic Tea", parent_id: nil, remote_image_url: "https://devtechperu-expatshop-dev.s3.amazonaws.com/uploads/ecommerce/category/image/17/Logo_website.jpg", status: "active", category_type: "primary", category_order: 10, main_menu: true, popular: false, popular_homepage: false, image_popular_homepage: nil, image_popular_homepage_overlay_text: "Organic Tea", homepage_cat_image_width: nil, homepage_cat_image_height: nil},
  {name: "Embossed Napkins", parent_id: 16, remote_image_url: "https://devtechperu-expatshop-dev.s3.amazonaws.com/uploads/ecommerce/category/image/19/Embossed_Napkin_iphone.jpg", status: "active", category_type: "primary", category_order: 3, main_menu: true, popular: false, popular_homepage: false, image_popular_homepage: nil, image_popular_homepage_overlay_text: "Embossed Napkins", homepage_cat_image_width: nil, homepage_cat_image_height: nil},
  {name: "Dinner Napkin", parent_id: 16, remote_image_url: "https://devtechperu-expatshop-dev.s3.amazonaws.com/uploads/ecommerce/category/image/21/Dinner_Napkins_Black.jpg", status: "active", category_type: "primary", category_order: 4, main_menu: true, popular: false, popular_homepage: false, image_popular_homepage: nil, image_popular_homepage_overlay_text: "Dinner Napkins", homepage_cat_image_width: nil, homepage_cat_image_height: nil},
  {name: "Dripless Taper Candles", parent_id: 16, remote_image_url: "https://devtechperu-expatshop-dev.s3.amazonaws.com/uploads/ecommerce/category/image/24/Candles_Gold_smaller.jpg", status: "active", category_type: "primary", category_order: 8, main_menu: true, popular: false, popular_homepage: false, image_popular_homepage: nil, image_popular_homepage_overlay_text: "Dripless Taper Candles", homepage_cat_image_width: nil, homepage_cat_image_height: nil},
  {name: "House of Germany", parent_id: nil, remote_image_url: "https://devtechperu-expatshop-dev.s3.amazonaws.com/uploads/ecommerce/category/image/16/Germany_Wider_Picture.jpg", status: "active", category_type: "secondary", category_order: 0, main_menu: true, popular: false, popular_homepage: true, image_popular_homepage: nil, image_popular_homepage_overlay_text: "House of Germany", homepage_cat_image_width: nil, homepage_cat_image_height: nil},
  {name: "House of Canada", parent_id: nil, remote_image_url: "https://devtechperu-expatshop-dev.s3.amazonaws.com/uploads/ecommerce/category/image/1/house_of_canada.png", status: "inactive", category_type: "secondary", category_order: 0, main_menu: true, popular: false, popular_homepage: true, image_popular_homepage: nil, image_popular_homepage_overlay_text: "House of Canada", homepage_cat_image_width: "400.0", homepage_cat_image_height: "233.0"},
  {name: "House of Israel", parent_id: nil, remote_image_url: "https://devtechperu-expatshop-dev.s3.amazonaws.com/uploads/ecommerce/category/image/10/house_of_israel.png", status: "inactive", category_type: "secondary", category_order: 19, main_menu: true, popular: false, popular_homepage: true, image_popular_homepage: nil, image_popular_homepage_overlay_text: "House of Israel", homepage_cat_image_width: "400.0", homepage_cat_image_height: "233.0"},
  {name: "House of Australia", parent_id: nil, remote_image_url: "https://devtechperu-expatshop-dev.s3.amazonaws.com/uploads/ecommerce/category/image/9/house_of_australia.png", status: "inactive", category_type: "secondary", category_order: 18, main_menu: true, popular: false, popular_homepage: true, image_popular_homepage: nil, image_popular_homepage_overlay_text: "House of Australia", homepage_cat_image_width: "400.0", homepage_cat_image_height: "233.0"},
  {name: "Baby Products", parent_id: nil, remote_image_url: "https://devtechperu-expatshop-dev.s3.amazonaws.com/uploads/ecommerce/category/image/11/baby_products.png", status: "inactive", category_type: "primary", category_order: 0, main_menu: true, popular: false, popular_homepage: false, image_popular_homepage: nil, image_popular_homepage_overlay_text: "Baby Products", homepage_cat_image_width: nil, homepage_cat_image_height: nil},
  {name: "Household", parent_id: nil, remote_image_url: "https://devtechperu-expatshop-dev.s3.amazonaws.com/uploads/ecommerce/category/image/12/household_items.png", status: "inactive", category_type: "primary", category_order: 1, main_menu: true, popular: false, popular_homepage: false, image_popular_homepage: nil, image_popular_homepage_overlay_text: "Household", homepage_cat_image_width: nil, homepage_cat_image_height: nil},
  {name: "House of USA", parent_id: nil, remote_image_url: "https://devtechperu-expatshop-dev.s3.amazonaws.com/uploads/ecommerce/category/image/2/house_of_usa.png", status: "inactive", category_type: "secondary", category_order: 1, main_menu: true, popular: false, popular_homepage: true, image_popular_homepage: nil, image_popular_homepage_overlay_text: "House of USA", homepage_cat_image_width: "400.0", homepage_cat_image_height: "233.0"},
  {name: "House of England", parent_id: nil, remote_image_url: "https://devtechperu-expatshop-dev.s3.amazonaws.com/uploads/ecommerce/category/image/3/house_of_england.png", status: "inactive", category_type: "secondary", category_order: 2, main_menu: true, popular: false, popular_homepage: true, image_popular_homepage: nil, image_popular_homepage_overlay_text: "House of England", homepage_cat_image_width: "400.0", homepage_cat_image_height: "233.0"},
  {name: "Specialized Food", parent_id: nil, remote_image_url: "https://devtechperu-expatshop-dev.s3.amazonaws.com/uploads/ecommerce/category/image/13/specialized_food_items.png", status: "inactive", category_type: "primary", category_order: 2, main_menu: true, popular: false, popular_homepage: false, image_popular_homepage: nil, image_popular_homepage_overlay_text: "Specialized Food", homepage_cat_image_width: nil, homepage_cat_image_height: nil},
  {name: "House of France", parent_id: nil, remote_image_url: "https://devtechperu-expatshop-dev.s3.amazonaws.com/uploads/ecommerce/category/image/4/house_of_france.png", status: "inactive", category_type: "secondary", category_order: 3, main_menu: true, popular: false, popular_homepage: true, image_popular_homepage: nil, image_popular_homepage_overlay_text: "House of France", homepage_cat_image_width: "400.0", homepage_cat_image_height: "233.0"},
  {name: "Ethnic Food", parent_id: nil, remote_image_url: "https://devtechperu-expatshop-dev.s3.amazonaws.com/uploads/ecommerce/category/image/14/ethnic_food_items.png", status: "inactive", category_type: "primary", category_order: 3, main_menu: true, popular: false, popular_homepage: false, image_popular_homepage: nil, image_popular_homepage_overlay_text: "Ethnic Food", homepage_cat_image_width: nil, homepage_cat_image_height: nil},
  {name: "Cosmetics", parent_id: nil, remote_image_url: "https://devtechperu-expatshop-dev.s3.amazonaws.com/uploads/ecommerce/category/image/15/cosmetic_items.png", status: "inactive", category_type: "primary", category_order: 4, main_menu: true, popular: false, popular_homepage: false, image_popular_homepage: nil, image_popular_homepage_overlay_text: "Cosmetics", homepage_cat_image_width: nil, homepage_cat_image_height: nil},
  {name: "House of Czech Republic", parent_id: nil, remote_image_url: "https://devtechperu-expatshop-dev.s3.amazonaws.com/uploads/ecommerce/category/image/5/house_of_czech_republic.png", status: "inactive", category_type: "secondary", category_order: 6, main_menu: true, popular: false, popular_homepage: true, image_popular_homepage: nil, image_popular_homepage_overlay_text: "House of Czech Republic", homepage_cat_image_width: "400.0", homepage_cat_image_height: "233.0"},
  {name: "House of Italy", parent_id: nil, remote_image_url: "https://devtechperu-expatshop-dev.s3.amazonaws.com/uploads/ecommerce/category/image/6/house_of_italy.png", status: "inactive", category_type: "secondary", category_order: 7, main_menu: true, popular: false, popular_homepage: true, image_popular_homepage: nil, image_popular_homepage_overlay_text: "House of Italy", homepage_cat_image_width: "400.0", homepage_cat_image_height: "233.0"},
  {name: "House of Arab", parent_id: nil, remote_image_url: "https://devtechperu-expatshop-dev.s3.amazonaws.com/uploads/ecommerce/category/image/7/blue_mosque.jpeg", status: "inactive", category_type: "secondary", category_order: 16, main_menu: true, popular: false, popular_homepage: true, image_popular_homepage: nil, image_popular_homepage_overlay_text: "House of Arab", homepage_cat_image_width: "400.0", homepage_cat_image_height: "233.0"},
  {name: "Textile Touch Napkins", parent_id: 16, remote_image_url: "https://devtechperu-expatshop-dev.s3.amazonaws.com/uploads/ecommerce/category/image/22/Textile_Touch_Napkins.jpg", status: "active", category_type: "primary", category_order: 5, main_menu: true, popular: false, popular_homepage: false, image_popular_homepage: nil, image_popular_homepage_overlay_text: "Textile Touch Napkins", homepage_cat_image_width: nil, homepage_cat_image_height: nil}
])
=end
Ecommerce::Product.create!([
  {category_list: ["House of Germany", "Cocktail Napkins"], brand_id: 6, supplier_id: 3, name: "Hearts", short_description: "", description: "Hearts", remote_image_url: "https://devtechperu-expatshop-dev.s3.amazonaws.com/uploads/ecommerce/product/image/8/C_767991.jpg", permalink: "Hearts", price_cents: 890, discounted_price_cents: 890, meta_keywords: nil, meta_description: nil, stockable: true, home_featured: false, category_featured: false, available_at: nil, deleted_at: nil, description2: ""},
  {category_list: ["House of Germany", "Cocktail Napkins"], brand_id: 6, supplier_id: 3, name: "Bunnies in Love", short_description: "", description: "Bunnies in Love", remote_image_url: "https://devtechperu-expatshop-dev.s3.amazonaws.com/uploads/ecommerce/product/image/9/C_702600.jpg", permalink: "Bunnies in Love", price_cents: 890, discounted_price_cents: 890, meta_keywords: nil, meta_description: nil, stockable: true, home_featured: false, category_featured: false, available_at: nil, deleted_at: nil, description2: ""},
  {category_list: ["House of Germany", "Cocktail Napkins"], brand_id: 6, supplier_id: 3, name: "Let's Celebrate", short_description: "", description: "Let's Celebrate", remote_image_url: "https://devtechperu-expatshop-dev.s3.amazonaws.com/uploads/ecommerce/product/image/10/C_756909.jpg", permalink: "Let's Celebrate", price_cents: 890, discounted_price_cents: 890, meta_keywords: nil, meta_description: nil, stockable: true, home_featured: false, category_featured: false, available_at: nil, deleted_at: nil, description2: ""},
  {category_list: ["Organic Tea"], brand_id: 5, supplier_id: 2, name: "Box of 9 Blends", short_description: "", description: "Organic Tea Box of 9 Blends - Cacao, Green tea, Black tea, Mango, Apple, Red Fruits, Herbal, Floral, Andean Mint", remote_image_url: "https://devtechperu-expatshop-dev.s3.amazonaws.com/uploads/ecommerce/product/image/6/Picture_of_Box.jpg", permalink: "Box of 9 Blends", price_cents: 17000, discounted_price_cents: 17000, meta_keywords: nil, meta_description: nil, stockable: true, home_featured: false, category_featured: false, available_at: nil, deleted_at: nil, description2: ""},
  {category_list: ["House of Germany", "Cocktail Napkins"], brand_id: 6, supplier_id: 3, name: "Vintage Angel", short_description: "", description: "Vintage Angel", remote_image_url: "https://devtechperu-expatshop-dev.s3.amazonaws.com/uploads/ecommerce/product/image/14/C_799200.jpg", permalink: "Vintage Angel", price_cents: 890, discounted_price_cents: 890, meta_keywords: nil, meta_description: nil, stockable: true, home_featured: false, category_featured: false, available_at: nil, deleted_at: nil, description2: ""},
  {category_list: ["House of Germany", "Cocktail Napkins"], brand_id: 6, supplier_id: 3, name: "Hip Hip Hooray", short_description: "", description: "Hip Hip Hooray", remote_image_url: "https://devtechperu-expatshop-dev.s3.amazonaws.com/uploads/ecommerce/product/image/15/C_782610.jpg", permalink: "Hip Hip Hooray", price_cents: 890, discounted_price_cents: 890, meta_keywords: nil, meta_description: nil, stockable: true, home_featured: false, category_featured: false, available_at: nil, deleted_at: nil, description2: ""},
  {category_list: ["House of Germany", "Cocktail Napkins"], brand_id: 6, supplier_id: 3, name: "Happy Beersday", short_description: "", description: "Happy Beersday", remote_image_url: "https://devtechperu-expatshop-dev.s3.amazonaws.com/uploads/ecommerce/product/image/16/C_783607.jpg", permalink: "Happy Beersday", price_cents: 890, discounted_price_cents: 890, meta_keywords: nil, meta_description: nil, stockable: true, home_featured: false, category_featured: false, available_at: nil, deleted_at: nil, description2: ""},
  {category_list: ["House of Germany", "Cocktail Napkins"], brand_id: 6, supplier_id: 3, name: "Palais Red", short_description: "", description: "Palais Red", remote_image_url: "https://devtechperu-expatshop-dev.s3.amazonaws.com/uploads/ecommerce/product/image/17/C_797010.jpg", permalink: "Palais Red", price_cents: 890, discounted_price_cents: 890, meta_keywords: nil, meta_description: nil, stockable: true, home_featured: false, category_featured: false, available_at: nil, deleted_at: nil, description2: ""},
  {category_list: ["House of Germany", "Cocktail Napkins"], brand_id: 6, supplier_id: 3, name: "Baloons", short_description: "", description: "Baloons", remote_image_url: "https://devtechperu-expatshop-dev.s3.amazonaws.com/uploads/ecommerce/product/image/18/C_783870.jpg", permalink: "Baloons", price_cents: 890, discounted_price_cents: 890, meta_keywords: nil, meta_description: nil, stockable: true, home_featured: false, category_featured: false, available_at: nil, deleted_at: nil, description2: ""},
  {category_list: ["House of Germany", "Cocktail Napkins"], brand_id: 6, supplier_id: 3, name: "Blue Lilies", short_description: "", description: "Blue Lilies", remote_image_url: "https://devtechperu-expatshop-dev.s3.amazonaws.com/uploads/ecommerce/product/image/19/C_770194.jpg", permalink: "Blue Lilies", price_cents: 890, discounted_price_cents: 890, meta_keywords: nil, meta_description: nil, stockable: true, home_featured: false, category_featured: false, available_at: nil, deleted_at: nil, description2: ""},
  {category_list: ["House of USA", "Household"], brand_id: 1, supplier_id: 1, name: "Bra Ball", short_description: "Bra Washer Protector Ball prevents winding among clothes.", description: "Design:a big hollow bra ball+a small clothes massage ball,just put underwear and small massage ball into big bra ball,then put it into washing machine,flower hollow design,fashion and launder bras without damage, protect bras from tangling and snagging. Safe alternative to hand washing,saving time,and washing cleaner.Keeps hooks from bending,cups keep their shape,bras last longer and look better. Suitable for all type of bras and bathing suits,also can be used as a suitcase travel bra protector.", remote_image_url: "https://devtechperu-expatshop-dev.s3.amazonaws.com/uploads/ecommerce/product/image/1/bra_ball.jpg", permalink: "Bra Ball", price_cents: 3000, discounted_price_cents: 3000, meta_keywords: nil, meta_description: nil, stockable: false, home_featured: false, category_featured: false, available_at: nil, deleted_at: nil, description2: "El Bra Ball the permite introducir el bra en una bola de plástico que podrá lavase en la lavadora sin dañar el bra, ni el resto de la ropa en la lavadora. Una segura alternativa a lavar a mano, ahorrando tiempo y obteniendo un mejor lavado."},
  {category_list: ["House of Germany", "Cocktail Napkins"], brand_id: 6, supplier_id: 3, name: "Wedding Rings", short_description: "", description: "Wedding Rings", remote_image_url: "https://devtechperu-expatshop-dev.s3.amazonaws.com/uploads/ecommerce/product/image/7/C_602609.jpg", permalink: "Wedding Rings", price_cents: 890, discounted_price_cents: 890, meta_keywords: nil, meta_description: nil, stockable: true, home_featured: false, category_featured: false, available_at: nil, deleted_at: nil, description2: ""},
  {category_list: ["House of Germany", "Cocktail Napkins"], brand_id: 6, supplier_id: 3, name: "Horses", short_description: "", description: "Horses", remote_image_url: "https://devtechperu-expatshop-dev.s3.amazonaws.com/uploads/ecommerce/product/image/11/C_776200.jpg", permalink: "Horses", price_cents: 890, discounted_price_cents: 890, meta_keywords: nil, meta_description: nil, stockable: true, home_featured: false, category_featured: false, available_at: nil, deleted_at: nil, description2: ""},
  {category_list: ["House of Germany", "Cocktail Napkins"], brand_id: 6, supplier_id: 3, name: "Baby Girl", short_description: "", description: "Baby Girl", remote_image_url: "https://devtechperu-expatshop-dev.s3.amazonaws.com/uploads/ecommerce/product/image/12/C_778759.jpg", permalink: "Baby Girl", price_cents: 890, discounted_price_cents: 890, meta_keywords: nil, meta_description: nil, stockable: true, home_featured: false, category_featured: false, available_at: nil, deleted_at: nil, description2: ""},
  {category_list: ["House of Germany", "Cocktail Napkins"], brand_id: 6, supplier_id: 3, name: "Baby Boy", short_description: "", description: "Baby Boy", remote_image_url: "https://devtechperu-expatshop-dev.s3.amazonaws.com/uploads/ecommerce/product/image/13/C_778749.jpg", permalink: "Baby Boy", price_cents: 890, discounted_price_cents: 890, meta_keywords: nil, meta_description: nil, stockable: true, home_featured: false, category_featured: false, available_at: nil, deleted_at: nil, description2: ""},
  {category_list: ["Large Napkins"], brand_id: 6, supplier_id: 3, name: "Paris", short_description: "", description: "Paris", remote_image_url: "https://devtechperu-expatshop-dev.s3.amazonaws.com/uploads/ecommerce/product/image/20/L_443200.jpg", permalink: "Paris", price_cents: 1390, discounted_price_cents: 1390, meta_keywords: nil, meta_description: nil, stockable: true, home_featured: false, category_featured: false, available_at: nil, deleted_at: nil, description2: ""},
  {category_list: ["Large Napkins"], brand_id: 6, supplier_id: 3, name: "Germany", short_description: "", description: "Germany", remote_image_url: "https://devtechperu-expatshop-dev.s3.amazonaws.com/uploads/ecommerce/product/image/21/L_741100.jpg", permalink: "Germany", price_cents: 1390, discounted_price_cents: 1390, meta_keywords: nil, meta_description: nil, stockable: true, home_featured: false, category_featured: false, available_at: nil, deleted_at: nil, description2: ""},
  {category_list: ["Large Napkins"], brand_id: 6, supplier_id: 3, name: "London", short_description: "", description: "London", remote_image_url: "https://devtechperu-expatshop-dev.s3.amazonaws.com/uploads/ecommerce/product/image/22/L_733500.jpg", permalink: "London", price_cents: 1390, discounted_price_cents: 1390, meta_keywords: nil, meta_description: nil, stockable: true, home_featured: false, category_featured: false, available_at: nil, deleted_at: nil, description2: ""},
  {category_list: ["Large Napkins"], brand_id: 6, supplier_id: 3, name: "Football", short_description: "", description: "Football", remote_image_url: "https://devtechperu-expatshop-dev.s3.amazonaws.com/uploads/ecommerce/product/image/23/L_453000.jpg", permalink: "Football", price_cents: 1390, discounted_price_cents: 1390, meta_keywords: nil, meta_description: nil, stockable: true, home_featured: false, category_featured: false, available_at: nil, deleted_at: nil, description2: ""},
  {category_list: ["Large Napkins", "House of Germany"], brand_id: 6, supplier_id: 3, name: "We Are The Champions", short_description: "", description: "We Are The Champions", remote_image_url: "https://devtechperu-expatshop-dev.s3.amazonaws.com/uploads/ecommerce/product/image/24/L_782309.jpg", permalink: "We Are The Champions", price_cents: 1390, discounted_price_cents: 1390, meta_keywords: nil, meta_description: nil, stockable: true, home_featured: false, category_featured: false, available_at: nil, deleted_at: nil, description2: ""},
  {category_list: ["House of Germany", "Embossed Napkins"], brand_id: 6, supplier_id: 3, name: "Gold Royalty", short_description: "", description: "Gold Royalty", remote_image_url: "https://devtechperu-expatshop-dev.s3.amazonaws.com/uploads/ecommerce/product/image/25/CF-L_17999.jpg", permalink: "Gold Royalty", price_cents: 1390, discounted_price_cents: 1390, meta_keywords: nil, meta_description: nil, stockable: true, home_featured: false, category_featured: false, available_at: nil, deleted_at: nil, description2: ""},
  {category_list: ["House of Germany", "Embossed Napkins"], brand_id: 6, supplier_id: 3, name: "Festive Time", short_description: "", description: "Festive Time", remote_image_url: "https://devtechperu-expatshop-dev.s3.amazonaws.com/uploads/ecommerce/product/image/26/LG_759009.jpg", permalink: "Festive Time", price_cents: 1390, discounted_price_cents: 1390, meta_keywords: nil, meta_description: nil, stockable: true, home_featured: false, category_featured: false, available_at: nil, deleted_at: nil, description2: ""},
  {category_list: ["House of Germany", "Embossed Napkins"], brand_id: 6, supplier_id: 3, name: "Red Hearts", short_description: "", description: "Red Hearts", remote_image_url: "https://devtechperu-expatshop-dev.s3.amazonaws.com/uploads/ecommerce/product/image/27/LH_17911.jpg", permalink: "Red Hearts", price_cents: 1390, discounted_price_cents: 1390, meta_keywords: nil, meta_description: nil, stockable: true, home_featured: false, category_featured: false, available_at: nil, deleted_at: nil, description2: ""},
  {category_list: ["Embossed Napkins"], brand_id: 6, supplier_id: 3, name: "Silver Royalty", short_description: "", description: "Pack of 16 Napkins", remote_image_url: "https://devtechperu-expatshop-dev.s3.amazonaws.com/uploads/ecommerce/product/image/28/CF-L_17995.jpg", permalink: "Silver Royalty", price_cents: 1390, discounted_price_cents: 1390, meta_keywords: nil, meta_description: nil, stockable: true, home_featured: false, category_featured: false, available_at: nil, deleted_at: nil, description2: ""},
  {category_list: ["House of Germany", "Embossed Napkins"], brand_id: 6, supplier_id: 3, name: "Embossed Gold Hearts", short_description: "", description: "Pack of 16 Napkins", remote_image_url: "https://devtechperu-expatshop-dev.s3.amazonaws.com/uploads/ecommerce/product/image/29/LG_744009.jpg", permalink: "Embossed Gold Hearts", price_cents: 1390, discounted_price_cents: 1390, meta_keywords: nil, meta_description: nil, stockable: true, home_featured: false, category_featured: false, available_at: nil, deleted_at: nil, description2: ""},
  {category_list: ["Embossed Napkins"], brand_id: 6, supplier_id: 3, name: "Saffron Royalty", short_description: "", description: "Pack of 16 Napkins", remote_image_url: "https://devtechperu-expatshop-dev.s3.amazonaws.com/uploads/ecommerce/product/image/30/CF-L_17918.jpg", permalink: "Saffron Royalty", price_cents: 1390, discounted_price_cents: 1390, meta_keywords: nil, meta_description: nil, stockable: true, home_featured: false, category_featured: false, available_at: nil, deleted_at: nil, description2: ""},
  {category_list: ["Embossed Napkins"], brand_id: 6, supplier_id: 3, name: "Gold Hearts", short_description: "", description: "Pack of 16 Napkins", remote_image_url: "https://devtechperu-expatshop-dev.s3.amazonaws.com/uploads/ecommerce/product/image/31/LH_17909.jpg", permalink: "Gold Hearts", price_cents: 1390, discounted_price_cents: 1390, meta_keywords: nil, meta_description: nil, stockable: true, home_featured: false, category_featured: false, available_at: nil, deleted_at: nil, description2: ""},
  {category_list: ["Embossed Napkins"], brand_id: 6, supplier_id: 3, name: "Green Royalty", short_description: "", description: "Pack of 16 Napkins", remote_image_url: "https://devtechperu-expatshop-dev.s3.amazonaws.com/uploads/ecommerce/product/image/32/CF-L_17920.jpg", permalink: "Green Royalty", price_cents: 1390, discounted_price_cents: 1390, meta_keywords: nil, meta_description: nil, stockable: true, home_featured: false, category_featured: false, available_at: nil, deleted_at: nil, description2: ""},
  {category_list: ["Dinner Napkin"], brand_id: 6, supplier_id: 3, name: "Palais Red Dinner Napkins", short_description: "", description: "Pack of 16 Napkins", remote_image_url: "https://devtechperu-expatshop-dev.s3.amazonaws.com/uploads/ecommerce/product/image/33/BF_797010.jpg", permalink: "Palais Red Dinner Napkins", price_cents: 1590, discounted_price_cents: 1590, meta_keywords: nil, meta_description: nil, stockable: true, home_featured: false, category_featured: false, available_at: nil, deleted_at: nil, description2: ""},
  {category_list: ["Dinner Napkin"], brand_id: 6, supplier_id: 3, name: "Grandeur Gold", short_description: "", description: "Pack of 16 Napkins", remote_image_url: "https://devtechperu-expatshop-dev.s3.amazonaws.com/uploads/ecommerce/product/image/34/BF_403696.jpg", permalink: "Grandeur Gold", price_cents: 1590, discounted_price_cents: 1590, meta_keywords: nil, meta_description: nil, stockable: true, home_featured: false, category_featured: false, available_at: nil, deleted_at: nil, description2: ""},
  {category_list: ["Dinner Napkin"], brand_id: 6, supplier_id: 3, name: "Blue Pearls", short_description: "", description: "Pack of 16 Napkins", remote_image_url: "https://devtechperu-expatshop-dev.s3.amazonaws.com/uploads/ecommerce/product/image/35/BF_600400.jpg", permalink: "Blue Pearls", price_cents: 1590, discounted_price_cents: 1590, meta_keywords: nil, meta_description: nil, stockable: true, home_featured: false, category_featured: false, available_at: nil, deleted_at: nil, description2: ""},
  {category_list: ["Dinner Napkin"], brand_id: 6, supplier_id: 3, name: "Paris Dinner Napkin", short_description: "", description: "Pack of 16 Napkins", remote_image_url: "https://devtechperu-expatshop-dev.s3.amazonaws.com/uploads/ecommerce/product/image/36/BF_729155.jpg", permalink: "Paris Dinner Napkin", price_cents: 1590, discounted_price_cents: 1590, meta_keywords: nil, meta_description: nil, stockable: true, home_featured: false, category_featured: false, available_at: nil, deleted_at: nil, description2: ""},
  {category_list: ["Dinner Napkin"], brand_id: 6, supplier_id: 3, name: "Blue Elegance", short_description: "", description: "Pack of 16 Napkins", remote_image_url: "https://devtechperu-expatshop-dev.s3.amazonaws.com/uploads/ecommerce/product/image/37/BF_790700.jpg", permalink: "Blue Elegance", price_cents: 1590, discounted_price_cents: 1590, meta_keywords: nil, meta_description: nil, stockable: true, home_featured: false, category_featured: false, available_at: nil, deleted_at: nil, description2: ""},
  {category_list: ["Dinner Napkin"], brand_id: 6, supplier_id: 3, name: "Palais White Black", short_description: "", description: "Pack of 16 Napkins", remote_image_url: "https://devtechperu-expatshop-dev.s3.amazonaws.com/uploads/ecommerce/product/image/38/BF_797097.jpg", permalink: "Palais White Black", price_cents: 1590, discounted_price_cents: 1590, meta_keywords: nil, meta_description: nil, stockable: true, home_featured: false, category_featured: false, available_at: nil, deleted_at: nil, description2: ""},
  {category_list: ["Textile Touch Napkins"], brand_id: 6, supplier_id: 3, name: "Black Velvet", short_description: "", description: "Pack of 12 Napkins", remote_image_url: "https://devtechperu-expatshop-dev.s3.amazonaws.com/uploads/ecommerce/product/image/39/VD_438107.jpg", permalink: "Black Velvet", price_cents: 1850, discounted_price_cents: 1850, meta_keywords: nil, meta_description: nil, stockable: true, home_featured: false, category_featured: false, available_at: nil, deleted_at: nil, description2: ""},
  {category_list: ["Textile Touch Napkins"], brand_id: 6, supplier_id: 3, name: "Home Sweet Home", short_description: "", description: "Pack of 12 Napkins", remote_image_url: "https://devtechperu-expatshop-dev.s3.amazonaws.com/uploads/ecommerce/product/image/40/VD_599507.jpg", permalink: "Home Sweet Home", price_cents: 1850, discounted_price_cents: 1850, meta_keywords: nil, meta_description: nil, stockable: true, home_featured: false, category_featured: false, available_at: nil, deleted_at: nil, description2: ""},
  {category_list: ["Textile Touch Napkins"], brand_id: 6, supplier_id: 3, name: "Velvet Cream Red", short_description: "", description: "Pack of 12 Napkins", remote_image_url: "https://devtechperu-expatshop-dev.s3.amazonaws.com/uploads/ecommerce/product/image/41/VD_438161.jpg", permalink: "Velvet Cream Red", price_cents: 1850, discounted_price_cents: 1850, meta_keywords: nil, meta_description: nil, stockable: true, home_featured: false, category_featured: false, available_at: nil, deleted_at: nil, description2: ""},
  {category_list: ["Textile Touch Napkins"], brand_id: 6, supplier_id: 3, name: "Grey Amelie", short_description: "", description: "Pack of 12 Napkins", remote_image_url: "https://devtechperu-expatshop-dev.s3.amazonaws.com/uploads/ecommerce/product/image/42/VD_734745.jpg", permalink: "Grey Amelie", price_cents: 1850, discounted_price_cents: 1850, meta_keywords: nil, meta_description: nil, stockable: true, home_featured: false, category_featured: false, available_at: nil, deleted_at: nil, description2: ""},
  {category_list: ["Textile Touch Napkins"], brand_id: 6, supplier_id: 3, name: "Classique Black", short_description: "", description: "Pack of 12 Napkins", remote_image_url: "https://devtechperu-expatshop-dev.s3.amazonaws.com/uploads/ecommerce/product/image/43/VD_739307.jpg", permalink: "Classique Black", price_cents: 1850, discounted_price_cents: 1850, meta_keywords: nil, meta_description: nil, stockable: true, home_featured: false, category_featured: false, available_at: nil, deleted_at: nil, description2: ""},
  {category_list: ["Dripless Taper Candles"], brand_id: 6, supplier_id: 3, name: "Gold Dripless Taper Candles", short_description: "", description: "6 Hour Long Burn Life. 24cm Tall", remote_image_url: "https://devtechperu-expatshop-dev.s3.amazonaws.com/uploads/ecommerce/product/image/44/K_122409.jpg", permalink: "Gold Dripless Taper Candles", price_cents: 900, discounted_price_cents: 900, meta_keywords: nil, meta_description: nil, stockable: true, home_featured: false, category_featured: false, available_at: nil, deleted_at: nil, description2: ""}
])
