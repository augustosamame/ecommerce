require "ecommerce/engine"
require 'decorators'
require "friendly_id"
#require 'carrierwave'
#require 'carrierwave/storage/fog'
require 'mini_magick'
require 'social-share-button'
require 'simple_form'
require 'material_icons'
require 'sass-rails'
require 'record_tag_helper'
require 'cocoon'
require 'font-awesome-rails'
require 'culqi-ruby'
require 'geocoder'
require "browser"
require "best_in_place"

module Ecommerce

  mattr_accessor :user_class #Can now reference this setting as Ecommerce.user_class
  mattr_accessor :ecommerce_layout
  mattr_accessor :site_name
  mattr_accessor :ecommerce_devise_layout
  mattr_accessor :use_main_app_header
  mattr_accessor :use_main_app_footer
  mattr_accessor :use_main_app_javascripts
  mattr_accessor :use_engine_header
  mattr_accessor :use_engine_footer
  mattr_accessor :custom_footer
  mattr_accessor :engine_alias_endpoint
  mattr_accessor :ask_for_email
  mattr_accessor :locale_set_by_store
  mattr_accessor :fb_app_id
  mattr_accessor :electronic_invoicing
  mattr_accessor :serie_boleta
  mattr_accessor :serie_factura
  mattr_accessor :serie_nota_de_credito
  mattr_accessor :shipping_integrator
  mattr_accessor :company_legal_name
  mattr_accessor :company_city
  mattr_accessor :company_street
  mattr_accessor :company_vat
  mattr_accessor :sales_email
  mattr_accessor :support_email
  mattr_accessor :phone_number

  mattr_accessor :address_requires_doc_id # :boolean, default: true # should state/state_name be required
  mattr_accessor :address_requires_phone # :boolean, default: true # Determines whether we require phone in address
  mattr_accessor :backoffice_interface_logo # :string, default: 'admin/logo.png'
  mattr_accessor :backoffice_products_per_page # :integer, default: Kaminari.config.default_per_page
  mattr_accessor :backoffice_orders_per_page # :integer, default: Kaminari.config.default_per_page
  mattr_accessor :backoffice_properties_per_page # :integer, default: Kaminari.config.default_per_page
  mattr_accessor :backoffice_promotions_per_page # :integer, default: Kaminari.config.default_per_page
  mattr_accessor :backoffice_users_per_page # :integer, default: Kaminari.config.default_per_page
  mattr_accessor :backoffice_default_locale
  mattr_accessor :hide_pricelists
  mattr_accessor :manual_order_approval
  mattr_accessor :store_default_locale
  mattr_accessor :allow_checkout_on_gateway_error # :boolean, default: false
  mattr_accessor :allow_guest_checkout # :boolean, default: true
  mattr_accessor :auto_credit_card_capture# :boolean, default: false # automatically capture the credit card (as opposed to just authorize and capture later)
  mattr_accessor :multi_currency # :string, default: 'USD'
  mattr_accessor :additional_currencies # :hash, {'USD', 'Dólares Americanos'}
  mattr_accessor :default_country_id # :integer (Country code: ex. Peru = 51)
  mattr_accessor :exchanges_days_window # :integer, default: 14 # the amount of days the customer has to exchange their item after the expedited exchange is shipped in order to avoid being charged
  mattr_accessor :returns_days_window # :integer, default: 14 # the amount of days the customer has to return their item after the expedited exchange is shipped in order to avoid being charged
  mattr_accessor :logo # :string, default: 'logo/spree_50.png'
  mattr_accessor :header_logo # :string, default: 'logo/spree_50.png'
  mattr_accessor :header_landing_logo # :string, default: 'logo/spree_50.png'
  mattr_accessor :footer_logo # :string, default: 'logo/spree_50.png'
  mattr_accessor :backoffice_logo # :string, default: 'logo/spree_50.png'
  mattr_accessor :products_per_page # :integer, default: 12
  mattr_accessor :min_restock_inventory # :boolean, default: true # Determines if a return item is restocked automatically once it has been received
  mattr_accessor :shipping_instructions_text# , :text, instructions/info for shipping
  mattr_accessor :track_inventory_levels # :boolean, default: true # Determines whether to track on_hand values for variants / products.
  mattr_accessor :default_currency
  mattr_accessor :enable_currency_selector
  mattr_accessor :enable_language_selector
  mattr_accessor :allow_coupons
  mattr_accessor :meta_tags_store_main_description
  mattr_accessor :secondary_menu_visible

  class << self

    #this lets us add functionality to main_app user model
    def decorate_user_class!

      #uncomment this next line if executing something in standalone engine folder
      #if Ecommerce.const_defined?(user_class) #required in dev mode when testing standalone engine
        Ecommerce.user_class.class_eval do
          #examples of extending or including functionality through local engine gems to user model
          #extend Ecommerce::Autocomplete
          #include Ecommerce::DefaultPermissions

          has_many :orders, :class_name => "Ecommerce::Order", :foreign_key => "user_id"
          has_many :addresses, :class_name => "Ecommerce::Address", :foreign_key => "user_id"
          has_one :cart, :class_name => "Ecommerce::Cart", :foreign_key => "user_id"
          has_one :data_biz_invoice, :class_name => "Ecommerce::DataBizInvoice", :foreign_key => "user_id"
          accepts_nested_attributes_for :data_biz_invoice


          #example of adding a method to User model
          #def moderate_posts?
          #  Ecommerce.moderate_first_post && !forem_approved_to_post?
          #end
          #alias_method :forem_needs_moderation?, :forem_moderate_posts?

        end
      #end
    end

  end

end
