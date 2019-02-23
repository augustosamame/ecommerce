module Ecommerce
  class Payment < ApplicationRecord
    belongs_to :user
    belongs_to :order, optional: true
    belongs_to :payment_method

    enum status: {status_exception: 0, active: 1, void: 2, refunded: 3, pending: 4}

    #monetize :amount_cents, :as => "amount"

    after_commit :check_if_order_paid

    #necessary so simple_form will not convert to UTC
    def date_before_type_cast
      self[:date].to_s
    end

    def check_if_order_paid
      self.order.update(process_comments: self.payment_method.name)
      unless self.pending?
        if Payment.where(order: self.order_id).sum(:amount_cents) >= self.order.amount_cents
          self.order.update(stage: "stage_paid", payment_status: "paid")
          TwilioIntegration.new.send_sms_to_number("Your ExpatShop Order No. #{self.order_id} has been Paid! We will let you know when we ship.", self.user.username) if Rails.env == "production"
          Campaign.send_recipients(self.order.try(:id))
        end
      end
    end

    def new_culqi_payment(current_user, card_token_data, amount, currency, payment_type, order_id = nil, payment_request_id = nil)
      Rails.logger.debug "Received Order: #{order_id}"
      Rails.logger.debug "Card Token Data:"
      Rails.logger.debug card_token_data
      case payment_type
      when "Recarga"
        culqi_description = "Recarga Saldo"
        culqi_orden = "Recarga Saldo"
        culqi_request = "Recarga Saldo"
      when "Order"
        culqi_description = "Order # #{order_id}"
        culqi_order = "Order # #{order_id}"
        culqi_request = "Request # #{payment_request_id}"
      end
      first_address = Address.where(user_id: current_user.id).first
      culqi_address = first_address.blank? ? "" : "#{first_address.street},#{first_address.street2.blank? ? "" : (first_address.street2 + ",")} #{first_address.district}"
      no_antifraud_data = culqi_address.blank? || current_user.first_name.blank? || current_user.last_name.blank?
      plain_mobile = current_user.username ? current_user.username.gsub(/[^\d]/, '') : ( current_user.phone ? current_user.phone.gsub(/[^\d]/, '') : "" )
      plain_mobile = plain_mobile[2..-1] if plain_mobile[0..1] == '51'
      antifraud_hash = no_antifraud_data ? nil : {
          :first_name => current_user.first_name,
          :last_name =>  current_user.last_name,
          :address => culqi_address,
          :address_city => "LIMA",
          :country_code => "PE",
          :phone_number => plain_mobile.blank? ? "986976377" : plain_mobile
      }
      Rails.logger.debug "Antifraud Hash: #{antifraud_hash}"
      charge = Culqi::Charge.create(
      :first_name => current_user.first_name,
      :last_name => current_user.last_name,
      :phone_number => current_user.phone || "986976377",
      :amount => amount.to_i,
      :capture => true,
      :currency_code => currency,
      :description => culqi_description,
      :email => card_token_data.payment_email,
      :antifraud_details => (antifraud_hash),
      :metadata => ({
          :usuario => current_user.id,
          :orden => culqi_order,
          :solicitud_de_pago => culqi_request
      }),
      :source_id => card_token_data.processor_token
      )
      Rails.logger.debug charge
      response = JSON.parse(charge)

      if response["outcome"] && response["outcome"]["type"] == "venta_exitosa"
        success = false
        Payment.transaction do
          new_payment = Payment.new
          new_payment.user_id = current_user.id
          new_payment.payment_method_id = PaymentMethod.find_by!(name: "Card").id
          new_payment.processor_transaction_id = response["id"]
          new_payment.processor_token = response["reference_code"]
          new_payment.amount_cents = response["amount"]
          new_payment.date = Time.now
          new_payment.status = "active"
          new_payment.order_id = order_id
          new_payment.payment_request_id = payment_request_id

          success = new_payment.save
          puts new_payment.errors.inspect unless success
          #if recharging
          #old_saldo = current_user.saldo_cents
          #current_user.update(saldo_cents: old_saldo + amount.to_i)
        end
        #TODO notify admin when response from Culqi was successful but transaction failed
        #TODO in this case user is charged but platform will not reflect it
        return success, "Error al guardar el pago"
      else
        success = false
        if response["object"] == "error"
          error_message = "#{response['user_message']} #{response['merchant_message']}" || "Error al intentar realizar el pago"
          return success, error_message
        else
          return success, "Error interno al procesar el pago"
        end
      end

    end

    def new_pagoefectrivo_payment(current_user, culqi_order_id, amount, currency, payment_type, order_id = nil, payment_request_id = nil)
      Rails.logger.debug "Received Order: #{order_id}"
      Rails.logger.debug "Pagoefectivo Order Id:"
      Rails.logger.debug culqi_order_id
      case payment_type
      when "Recarga"
        culqi_description = "Recarga Saldo"
        culqi_orden = "Recarga Saldo"
        culqi_request = "Recarga Saldo"
      when "Order"
        culqi_description = "Order # #{order_id}"
        culqi_order = "Order # #{order_id}"
        culqi_request = "Request # #{payment_request_id}"
      end
      Payment.transaction do
        new_payment = Payment.new
        new_payment.user_id = current_user.id
        new_payment.payment_method_id = PaymentMethod.find_by!(name: "PagoEfectivo").id
        new_payment.processor_transaction_id = culqi_order_id
        new_payment.amount_cents = amount
        new_payment.date = Time.now
        new_payment.status = "pending"
        new_payment.order_id = order_id
        new_payment.payment_request_id = payment_request_id

        success = new_payment.save
        puts new_payment.errors.inspect unless success
        #if recharging
        #old_saldo = current_user.saldo_cents
        #current_user.update(saldo_cents: old_saldo + amount.to_i)
      end

    end


  end
end
