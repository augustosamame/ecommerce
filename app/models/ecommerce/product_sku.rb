# Variant can be thought of as specific types of product.
#
# A product could be considered Levis 501 Blues
#   => Then a variant would specify the color and size of a specific pair of Jeans
#

# == Schema Information
#
# Table name: variants
#
#  id           :integer(4)      not null, primary key
#  product_id   :integer(4)      not null
#  sku          :string(255)     not null
#  name         :string(255)
#  price        :decimal(8, 2)   default(0.0), not null
#  cost         :decimal(8, 2)   default(0.0), not null
#  deleted_at   :datetime
#  master       :boolean(1)      default(FALSE), not null
#  created_at   :datetime
#  updated_at   :datetime
#  inventory_id :integer(4)
#
module Ecommerce
  class ProductSku < ApplicationRecord

    has_many :product_sku_properties
    has_many :properties, through: :product_sku_properties

    belongs_to :product

    validates :price_cents, presence: true
    validates :sku, presence: true,       length: { maximum: 255 }

    accepts_nested_attributes_for :product_sku_properties, reject_if: proc { |attributes| attributes['description'].blank? }, allow_destroy: true

    delegate  :brand, to: :product, allow_nil: true

    ADMIN_OUT_OF_STOCK_QTY  = 0
    OUT_OF_STOCK_QTY        = 2
    LOW_STOCK_QTY           = 6

    def featured_image(image_size = :small)
      image_urls(image_size).first
    end

    def image_urls(image_size = :small)
      Rails.cache.fetch("variant-image_urls-#{self}-#{image_size}", expires_in: 3.hours) do
        image_group ? image_group.image_urls(image_size) : product.image_urls(image_size)
      end
    end

    # returns an array of the display name and description of all the variant properties
    #  ex: obj.sub_name => ['color: green', 'size: 9.0']
    #
    # @param [Optional String]
    # @return [Array]
    def property_details(separator = ': ')
      product_sku_properties.collect {|vp| [vp.property.display_name ,vp.description].join(separator) }
    end

    # returns a string the display name and description of all the variant properties
    #  ex: obj.sub_name => 'color: green <br/> size: 9.0']
    #
    # @param [Optional String] separator (default == <br/>)
    # @return [String]
    def display_property_details(separator = '<br/>')
      property_details.join(separator)
    end

    # returns the product name
    #  ex: obj.product_name => Nike
    #
    # @param [none]
    # @return [String]
    def product_name
      name? ? name : [product.name, sub_name].reject{ |a| a.strip.length == 0 }.join(' - ')
    end

    # returns the primary_property's description or a blank string
    #  ex: obj.sub_name => 'great shoes, blah blah blah'
    #
    # @param [none]
    # @return [String]
    def sub_name
      primary_property ? "#{primary_property.description}" : ''
    end

    # returns the brand's name or a blank string
    #  ex: obj.brand_name => 'Nike'
    #
    # @param [none]
    # @return [String]
    def brand_name
      product.brand_name
    end

    # The variant has many properties.  but only one is the primary property
    #  this will return the primary property.  (good for primary info)
    #
    # @param [none]
    # @return [VariantProperty]
    def primary_property
      pp = self.variant_properties.find_by(primary: true)
      pp ? pp : self.product_sku_properties.first
    end

    # returns the product name with sku
    #  ex: obj.name_with_sku => Nike: 1234-12345-1234
    #
    # @param [none]
    # @return [String]
    def name_with_sku
      [product_name, sku].compact.join(': ')
    end

    # returns true or false based on if the count_available is above 0
    #
    # @param [Integer] number of variants to subtract
    # @return [Boolean]
    def is_available?
      stock > 0
    end

    # returns number available to purchase
    #
    # @param [Boolean] reload the object from the DB
    # @return [Integer] number available to purchase
    def count_available(reload_variant = true)
      self.reload if reload_variant
      count_on_hand - count_pending_to_customer
    end

  end
end
