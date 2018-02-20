module Ecommerce
  class Control < ApplicationRecord
    before_save :set_top_bar_hash, if: Proc.new { |control| control.name == "top_bar_html" }

    def set_top_bar_hash
      random_hash = SecureRandom.uuid
      Control.find_by(name: "top_bar_cookie_read_hash").update(text_value: random_hash)

    end

    def self.get_control_value(control_name)
      found_control = self.find_by(name: control_name)
      if found_control
        case found_control.value_field_type
        when "text"
          found_control.text_value
        when "boolean"
          found_control.boolean_value
        when "integer"
          found_control.integer_value
        when "float"
          found_control.float_value
        when "date"
          found_control.date_value
        else
          return nil
        end
      else
        return nil
      end

    end




  end
end
