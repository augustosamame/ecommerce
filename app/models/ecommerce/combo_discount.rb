module Ecommerce
  class ComboDiscount < ApplicationRecord
    #has_many :orders
    #has_many :products
    #has_and_belongs_to_many :products, join_table: :coupons_products

    enum status: {active: 0, inactive: 1}
    enum discount_type: {percentage_discount: 0, fixed_discount: 1}

    validates_presence_of :name, :description_en, :description_es, :product_id_1, :qty_product_1, :discount_type, :discount_amount

    validate :validations_for_combo_applies

    def validations_for_combo_applies
      product_1 = Ecommerce::Product.where(id: self.product_id_1)
      errors.add(:combo_products, 'All products must exist.') if product_1.blank?

      if self.product_id_2.present?
        product_2 = Ecommerce::Product.where(id: self.product_id_2)
        errors.add(:combo_products, 'All products must exist.') if product_2.blank?
      end
    end

    def product_1
      Ecommerce::Product.find_by(id: self.product_id_1).try(:name)
    end

    def product_2
      Ecommerce::Product.find_by(id: self.product_id_2).try(:name)
    end

  end
end
