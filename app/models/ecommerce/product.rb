module Ecommerce
  class Product < ApplicationRecord
    include Ecommerce::SessionInfo

    translates :name, :short_description, :description
    globalize_accessors :locales => [:"en-PE", :"es-PE"], :attributes => [:name, :short_description, :description]

    belongs_to :category, optional: true
    belongs_to :brand
    belongs_to :supplier
    #belongs_to :coupon, optional: true
    has_and_belongs_to_many :coupons, join_table: :coupons_products

    has_many :product_properties
    has_many :properties, through: :product_properties
    has_many :product_skus, inverse_of: :product
    has_many :product_taxes, inverse_of: :product, dependent: :destroy
    has_many :active_variants, -> { where(deleted_at: nil) }, class_name: 'ProductSku'
    has_many :product_prices

    #after_commit :create_product_taxes, on: :create

    attr_accessor :tax_1_check, :tax_2_check, :tax_3_check, :tax_1_amount, :tax_2_amount, :tax_3_amount
    attr_accessor :temp_product_price, :search

    extend FriendlyId
    friendly_id :permalink_candidates, use: :slugged, slug_column: :permalink

    include PgSearch
    pg_search_scope :search_by_name, associated_against: { translations: :name }, using: {tsearch: {prefix: true, any_word: true}}

    scope :in_stock, -> { where("stockable = ? or total_quantity != ?", false, 0) }
    scope :active, -> { where(status: "active") }

    paginates_per 8

    enum status: {active: 0, inactive: 1}

    acts_as_taggable_on :categories

    accepts_nested_attributes_for :product_skus, reject_if: proc { |attributes| attributes['sku'].blank? }, :allow_destroy => true
    accepts_nested_attributes_for :product_properties, reject_if: proc { |attributes| attributes['description'].blank? }, allow_destroy: true
    #accepts_nested_attributes_for :images,             reject_if: proc { |t| (t['photo'].nil? && t['photo_from_link'].blank? && t['id'].blank?) }, allow_destroy: true

    mount_uploader :image, Ecommerce::ProductImageUploader

    monetize :price_cents
    monetize :discounted_price_cents
    monetize :usd_price_cents
    monetize :usd_discounted_price_cents

    #validates :category_id, presence: true
    validates_presence_of :category_list
    validates :name, presence: true, length: { maximum: 165 }

    def permalink_candidates
      [
        :name,
        [:name, :id]
      ]
    end

    def in_stock?

      return self.total_quantity > 0
    end

    def discounted?
      self.discounted_price_cents < self.price_cents
    end

    def usd_current_price
      current_price
    end

    def pricelist_price_cents(pricelist)
      return ProductPrice.find_by(product_id: self.id, pricelist_id: pricelist.id).try(:price_cents)
    end

    def pricelist_discounted_price_cents(pricelist)
      return ProductPrice.find_by(product_id: self.id, pricelist_id: pricelist.id).try(:discounted_price_cents)
    end

    def pricelist_price(pricelist)
      return ProductPrice.find_by(product_id: self.id, pricelist_id: pricelist.id).try(:price)
    end

    def pricelist_discounted_price(pricelist)
      return ProductPrice.find_by(product_id: self.id, pricelist_id: pricelist.id).try(:discounted_price)
    end

    def current_price
      if Current.user.try(:pricelist_id).blank? || Ecommerce::ProductPrice.find_by(product_id: self.id, pricelist_id: Current.user.pricelist_id).blank?
        case Ecommerce::SessionInfo.current_session_currency
        when "usd"
          return [self.price, self.discounted_price].min  #all prices in dollars
        when "pen"
          return [self.price, self.discounted_price].min
        else
          return [self.price, self.discounted_price].min
        end
      else
        new_price = Ecommerce::ProductPrice.find_by(product_id: self.id, pricelist_id: Current.user.pricelist_id).price
        new_discounted_price = Ecommerce::ProductPrice.find_by(product_id: self.id, pricelist_id: Current.user.pricelist_id).discounted_price
        case Ecommerce::SessionInfo.current_session_currency
        when "usd"
          return [new_price, new_discounted_price].min  #all prices in dollars
        when "pen"
          return [new_price, new_discounted_price].min
        else
          return [new_price, new_discounted_price].min
        end
      end
    end

    def current_price_cents
      case Ecommerce::SessionInfo.current_session_currency
      when "usd"
        [self.price_cents, self.discounted_price_cents].min #all prices in dollars
      when "pen"
        [self.price_cents, self.discounted_price_cents].min
      else
        [self.price_cents, self.discounted_price_cents].min
      end
    end

    def create_product_taxes
      default_taxes = Ecommerce::Control.find_by!(name: "default_taxes").text_value.split(",")
      default_taxes.each_cons(2) { |tax, amount|
        found_tax = Ecommerce::Tax.find_by!(tax_name: tax)
        Ecommerce::ProductTax.create(tax_id: found_tax.id , product_id: self.id, tax_amount: amount.to_f)
      }
    end

    def translated_category_list
      tcl = Array.new
      self.category_list.each do |cl|
        category_id = Ecommerce::Category::Translation.find_by(locale: Ecommerce.backoffice_default_locale, name: cl).try(:ecommerce_category_id)
        translated_category = Ecommerce::Category::Translation.find_by(locale: I18n.locale, ecommerce_category_id: category_id).try(:name)
        tcl << (translated_category || cl)
      end
      return tcl

    end

  end
end
