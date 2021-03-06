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

## Main App Requirements:

Gems:

The following gems must be installed in main app:

gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'bootstrap-sass'
gem 'meta-tags', require: 'meta_tags'
gem "responders"
gem 'devise'
gem 'devise-i18n'
gem 'cancancan'
gem 'acts-as-taggable-on', github: "Fodoj/acts-as-taggable-on", branch: 'rails-5.2'

ActsAsTaggableOn requires an initializer with the following:

ActsAsTaggableOn.force_lowercase = true



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
t.string :cart_id
t.integer :status


Locale:

application.rb must set the locale to a supported locale:

config.i18n.default_locale = :'es-PE'


Include the Following Helper:

module LayoutHelper
  # Used to achieve nested layouts without content_for. This helper relies on
  # Rails internals, so beware that it make break with future major versions
  # of Rails. Inspired by http://stackoverflow.com/a/18214036
  #
  # Usage: For example, suppose "child" layout extends "parent" layout.
  # Use <%= yield %> as you would with non-nested layouts, as usual. Then on
  # the very last line of layouts/child.html.erb, include this:
  #
  #     <% parent_layout "parent" %>
  #
  def parent_layout(layout)
    @view_flow.set(:layout, output_buffer)
    output = render(:file => "layouts/#{layout}")
    self.output_buffer = ActionView::OutputBuffer.new(output)
  end
end


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

## Seed Data

Seed Data is required for engine configuration. To properly seed data from engine in main app add the following command to main_app seeds.rb:

```
Ecommerce::Engine.load_seed
```

and run in main_app terminal:

```
rails db:seed
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
Ecommerce.horizontal_logo = "PATH_TO_HORIZONTAL_LOGO"
Ecommerce.engine_alias_endpoint = 'tienda'
Ecommerce.locale_set_by_store = true
Ecommerce.fb_app_id = 'FB_APP_ID'
Ecommerce.shipping_integrator = 'Urbaner'
Ecommerce.electronic_invoicing = 'Nubefact'

## Features

Completely customizable ecommerce module
change layout and css to your custom design
manage categories, products, products attributes
Peruvian electronic invoicing
Credit Card payments via Culqi
integrates with 3rd party logistics partner (Olva, Urbaner)
configure via Control.
customizable marketing top-bar. If dismissed it won't appear again after new HTML top bar text is saved via backoffice

## v1.1 Planned Features

Mega_menu option in category so that main_menu categories can look like this: https://ibb.co/d0g5Db
Even better would be customizable menus (like Saga Falabella which can be chosen and completed with data)
Multilanguage strings for both store and backoffice

## v2.0 Planned Features

All products, categories, etc.. can have multilanguage values so user-facing ecommerce is multilanguage

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
