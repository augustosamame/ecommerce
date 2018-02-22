module Ecommerce
  class Product < ApplicationRecord
    belongs_to :category
    belongs_to :brand
    belongs_to :supplier

    has_many :product_properties
    has_many :properties, through: :product_properties
    has_many :product_skus, inverse_of: :product

    has_many :active_variants, -> { where(deleted_at: nil) },
    class_name: 'ProductSku'

    accepts_nested_attributes_for :product_skus, reject_if: proc { |attributes| attributes['sku'].blank? }, :allow_destroy => true
    accepts_nested_attributes_for :product_properties, reject_if: proc { |attributes| attributes['description'].blank? }, allow_destroy: true
    #accepts_nested_attributes_for :images,             reject_if: proc { |t| (t['photo'].nil? && t['photo_from_link'].blank? && t['id'].blank?) }, allow_destroy: true

    mount_uploader :image, Ecommerce::ProductImageUploader

    validates :category_id, presence: true
    validates :name, presence: true,   length: { maximum: 165 }

    def discounted?
      self.discounted_price_cents < self.price_cents
    end

  end
end
