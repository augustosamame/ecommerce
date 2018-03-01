module Ecommerce
  class Order < ApplicationRecord
    belongs_to :user

    enum stage: {stage_new: 0, stage_paid: 1, stage_shipped: 2, stage_delivered: 3, stage_closed: 4, stage_void: 5 }
    enum payment_status: {unpaid: 0, paid: 1, refunded: 2 }
    enum status: {active: 0, void: 2 }
  end
end
