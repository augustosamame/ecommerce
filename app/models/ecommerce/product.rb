module Ecommerce
  class Product < ApplicationRecord
    belongs_to :category, optional: true
    belongs_to :brand
    belongs_to :supplier

    has_many :product_properties
    has_many :properties, through: :product_properties
    has_many :product_skus, inverse_of: :product

    has_many :active_variants, -> { where(deleted_at: nil) },
    class_name: 'ProductSku'

    include PgSearch
    pg_search_scope :search_by_name, :against => :name, :using => {:tsearch => {:prefix => true}}

    scope :in_stock, -> { where("stockable = ? or total_quantity != ?", false, 0) }

    paginates_per 8

    acts_as_taggable_on :categories

    accepts_nested_attributes_for :product_skus, reject_if: proc { |attributes| attributes['sku'].blank? }, :allow_destroy => true
    accepts_nested_attributes_for :product_properties, reject_if: proc { |attributes| attributes['description'].blank? }, allow_destroy: true
    #accepts_nested_attributes_for :images,             reject_if: proc { |t| (t['photo'].nil? && t['photo_from_link'].blank? && t['id'].blank?) }, allow_destroy: true

    mount_uploader :image, Ecommerce::ProductImageUploader

    monetize :price_cents
    monetize :discounted_price_cents

    #validates :category_id, presence: true
    validates_presence_of :category_list
    validates :name, presence: true,   length: { maximum: 165 }

    def discounted?
      self.discounted_price_cents < self.price_cents
    end

    def current_price
      [self.price, self.discounted_price].min
    end

  end
end
