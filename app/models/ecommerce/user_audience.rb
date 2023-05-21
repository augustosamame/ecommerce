module Ecommerce
  class UserAudience < ApplicationRecord
    belongs_to :user
    belongs_to :audience

    enum status: {inactive: 0, active: 1}

    
  end
end
