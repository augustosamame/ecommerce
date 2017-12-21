module Ecommerce
  class Address < ApplicationRecord
    belongs_to :user
  end
end
