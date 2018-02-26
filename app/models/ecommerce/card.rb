module Ecommerce
  class Card < ApplicationRecord
    belongs_to :user

    enum status: {activa: 1, inactiva: 2}

    def create_new_from_culqi(current_user, culqi_data)
      card = Card.new
      card.user_id = current_user.id
      Rails.logger.debug culqi_data
      card.processor_token = culqi_data[:id]
      card.payment_email = culqi_data[:email]
      card.number = culqi_data[:card_number]
      card.bin = culqi_data[:iin][:bin]
      card.last_four = culqi_data[:last_four]
      card.brand = culqi_data[:iin][:card_brand]
      card.card_type = culqi_data[:iin][:card_type]
      card.issuer_name = culqi_data[:iin][:issuer][:name]
      card.issuer_country_code = culqi_data[:iin][:issuer][:country_code]
      card.status = culqi_data[:active] == "true" ? 1 : 2
      #TODO error_handling here
      if card.save
        return card
      else
        return nil
      end
    end
  end

end
