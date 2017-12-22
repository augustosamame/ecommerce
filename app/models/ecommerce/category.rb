module Ecommerce
  class Category < ApplicationRecord
    has_many :products
  end
end
