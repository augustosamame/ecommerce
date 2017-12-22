module Ecommerce
  class Product < ApplicationRecord
    belongs_to :category
  end
end
