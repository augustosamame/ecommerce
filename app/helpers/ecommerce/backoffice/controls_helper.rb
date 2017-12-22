module Ecommerce
  module Backoffice::ControlsHelper

    def single_set_value(shown_control)
      case shown_control.value_field_type
      when "text"
        shown_control.text_value
      when "boolean"
        shown_control.boolean_value
      when "integer"
        shown_control.integer_value
      when "float"
        shown_control.float_value
      when "date"
        shown_control.date_value
      end
    end
  end
end
