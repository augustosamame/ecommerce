module Ecommerce
  class WishlistMessage
    include ActiveModel::Model

    attr_accessor :name, :email, :phone, :product_name, :brand, :attributes, :country, :comment

    validates :name, :email, :phone, :product_name, presence: true

  end
end
