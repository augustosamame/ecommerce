module Ecommerce
  class WishlistMessage
    include ActiveModel::Model

    attr_accessor :name, :email, :phone, :product_name, :brand, :attributes, :country, :comment

  end
end
