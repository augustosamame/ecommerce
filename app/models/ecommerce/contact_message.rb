module Ecommerce
  class ContactMessage
    include ActiveModel::Model

    attr_accessor :name, :email, :phone, :message

  end
end
