require "ecommerce/engine"
require "friendly_id"
require 'carrierwave'
require 'carrierwave/storage/fog'
require 'mini_magick'
require 'social-share-button'
require 'simple_form'
require 'material_icons'
require 'sass-rails'
require 'bootstrap-sass'
require 'record_tag_helper'

module Ecommerce

  mattr_accessor :ecommerce_layout #Can now reference this setting as Ecommerce.ecommerce_layout
  mattr_accessor :use_main_app_header
  mattr_accessor :use_main_app_footer
  mattr_accessor :use_main_app_javascripts
  mattr_accessor :use_engine_header
  mattr_accessor :use_engine_footer

  mattr_accessor :address_requires_doc_id # :boolean, default: true # should state/state_name be required
  mattr_accessor :address_requires_phone # :boolean, default: true # Determines whether we require phone in address
  mattr_accessor :backoffice_interface_logo # :string, default: 'admin/logo.png'
  mattr_accessor :backoffice_products_per_page # :integer, default: Kaminari.config.default_per_page
  mattr_accessor :backoffice_orders_per_page # :integer, default: Kaminari.config.default_per_page
  mattr_accessor :backoffice_properties_per_page # :integer, default: Kaminari.config.default_per_page
  mattr_accessor :backoffice_promotions_per_page # :integer, default: Kaminari.config.default_per_page
  mattr_accessor :backoffice_users_per_page # :integer, default: Kaminari.config.default_per_page
  mattr_accessor :allow_checkout_on_gateway_error # :boolean, default: false
  mattr_accessor :allow_guest_checkout # :boolean, default: true
  mattr_accessor :auto_credit_card_capture# :boolean, default: false # automatically capture the credit card (as opposed to just authorize and capture later)
  mattr_accessor :multi_currency # :string, default: 'USD'
  mattr_accessor :additional_currencies # :hash, {'USD', 'Dólares Americanos'}
  mattr_accessor :default_country_id # :integer (Country code: ex. Peru = 51)
  mattr_accessor :exchanges_days_window # :integer, default: 14 # the amount of days the customer has to exchange their item after the expedited exchange is shipped in order to avoid being charged
  mattr_accessor :returns_days_window # :integer, default: 14 # the amount of days the customer has to return their item after the expedited exchange is shipped in order to avoid being charged
  mattr_accessor :logo # :string, default: 'logo/spree_50.png'
  mattr_accessor :products_per_page # :integer, default: 12
  mattr_accessor :min_restock_inventory # :boolean, default: true # Determines if a return item is restocked automatically once it has been received
  mattr_accessor :shipping_instructions_text# , :text, instructions/info for shipping
  mattr_accessor :track_inventory_levels # :boolean, default: true # Determines whether to track on_hand values for variants / products.

end
