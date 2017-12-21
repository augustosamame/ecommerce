module Ecommerce
  class Order < ApplicationRecord
    belongs_to :user
  end
end
