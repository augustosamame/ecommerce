module Ecommerce
  class Control < ApplicationRecord
    before_save :set_top_bar_hash, if: Proc.new { |control| control.name == "top_bar_html" }

    def set_top_bar_hash
      random_hash = SecureRandom.uuid
      Control.find_by(name: "top_bar_cookie_read_hash").update(text_value: random_hash)

    end



  end
end
