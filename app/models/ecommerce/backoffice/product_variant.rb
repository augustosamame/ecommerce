module Ecommerce
  class Backoffice::ProductVariant < ApplicationRecord
    belongs_to :product
  end
end
