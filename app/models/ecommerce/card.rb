module Ecommerce
  class Card < ApplicationRecord
    belongs_to :user

    enum status: {active: 1, void: 2}

    def create_new_from_culqi(current_user, culqi_data)
      card = Card.new
      card.user_id = current_user.id
      card.processor_token = culqi_data[:id]
      card.payment_email = culqi_data[:email]
      card.number = culqi_data[:card_number]
      card.bin = culqi_data[:iin][:bin]
      card.last_four = culqi_data[:last_four]
      card.brand = culqi_data[:iin][:card_brand]
      card.card_type = culqi_data[:iin][:card_type]
      card.issuer_name = culqi_data[:iin][:issuer][:name]
      card.issuer_country_code = culqi_data[:iin][:issuer][:country_code]
      # Culqi's `active` field arrives as either the boolean `true` (when the
      # backend fetches the token via Culqi::Token.get and JSON-parses with
      # symbolize_names) or the string "true" (legacy web checkout posts the
      # whole token object as form data). Normalize via .to_s so both work.
      # The enum only defines :active and :void — there is no "inactive" — so
      # an inactive token falls back to "void".
      card.status = culqi_data[:active].to_s == "true" ? "active" : "void"
      #TODO error_handling here
      if card.save
        return card
      else
        return nil
      end
    end
  end

end
