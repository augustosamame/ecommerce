module Ecommerce
  class EmailClick < ApplicationRecord
    self.table_name = "ecommerce_email_clicks"

    belongs_to :email_send, class_name: "Ecommerce::EmailSend"
  end
end
