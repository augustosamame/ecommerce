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


## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
