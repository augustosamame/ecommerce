# Ecommerce
This engine will add ecommerce capabilities to any of DevTechPeru´s projects.

## Usage
After following installation instructions, a new online store will be available at selected endpoint (ex. /tienda). The main application's Devise user will be available, as well as all main Application Controller methods (and soon helpers). CanCanCan Roles can also be added to Engines own Ability class and they will be merged into main app's Ability class.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'ecommerce'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install ecommerce
```

Mount the engine in your routes:

```
mount Ecommerce::Engine, at: "/tienda", as: "ecommerce"
```

Main App Requirements:

Gems:

The following gems must be installed in main app:

gem 'jquery-rails' #already includes gem 'jquery-ui-rails'
gem 'jquery-ui-rails'
gem 'bootstrap-sass'
gem 'meta-tags', require: 'meta_tags'
gem "responders"
gem 'devise'
gem 'devise-i18n'
gem 'cancancan'

User Model

The Ecommerce engine expects the following User model schema to be present:

t.string :email (Devise default)
t.string :password (Devise default)
t.integer :role, default: 0, null: false (for CanCanCan authorizations)
t.string :first_name, null: false
t.string :last_name, null: false
t.string :phone
t.string :username
t.string :address
t.string :doc_id
t.string :avatar
t.integer :status

Assets

main_app application.scss and application.js must include:

ex.

```
application.scss

*
*=
*/

@import 'ecommerce/backoffice/globals/fonts';
@import 'ecommerce/backoffice/globals/variables';


// --------------Bootstrap-----------------------------
@import 'bootstrap-sprockets';
@import 'bootstrap';

@import 'bootstrap-datetimepicker';

@import 'devise_bootstrap_views';
@import 'bootstrap-datetimepicker';
@import 'material_icons';
@import 'custom_APP_NAME';


application.js

//= require jquery
//= require jquery_ujs
//= require bootstrap-sprockets
//= require moment
//= require moment/es
//= require bootstrap-datetimepicker


```


## Migrations

copy over and run migrations with

```
rails ecommerce:install:migrations
rails db:migrate
```

Note: special care needs to be taken when creating and copying over a migration with relations from the namespaced engine, since rails fails to recognize the namespace for the foreign keys. See create_ecommerce_product_skus for a working example
Basically you have to remove the foreign_key: true from the field and add the foreign key manually by using:

```
add_foreign_key :ecommerce_product_skus, :ecommerce_products, column: :product_id
```


## Configuration
The following configurations need to be set by creating ecommerce.rb in initializers/ecommerce.rb:

Ecommerce.ecommerce_layout = "canvas_ecommerce"
Ecommerce.use_main_app_header = true
Ecommerce.use_main_app_footer = true
Ecommerce.use_main_app_javascripts = true
Ecommerce.use_engine_header = false
Ecommerce.use_engine_footer = false
Ecommerce.logo = "PATH_TO_LOGO"


## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
