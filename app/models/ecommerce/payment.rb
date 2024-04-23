module Ecommerce
  class Payment < ApplicationRecord
    belongs_to :user
    belongs_to :order, optional: true
    belongs_to :payment_method

    enum status: {status_exception: 0, active: 1, void: 2, refunded: 3, pending: 4}

    monetize :amount_cents, :as => "amount"

    after_commit :check_if_order_paid
    after_commit :check_if_referrer_first_sale

    def check_if_referrer_first_sale
      points_payment_method = PaymentMethod.find_by(name: "Points")
      if !self.user.referral_paid && !self.user.referrer_id.blank? && self.payment_method_id != points_payment_method.id
        referring_user = User.find_by(referral_code: self.user.referrer_id)
        ActiveRecord::Base.transaction do
          self.user.update(referral_paid: true)
          PointsTransaction.create(user_id: self.user.referrer_id, points: ((self.amount_cents) * 0.05).floor, tx_type: 'referral', tx_id: self.order.id, referred_user_id: self.user.id)
        end
      end
    end

    #necessary so simple_form will not convert to UTC
    def date_before_type_cast
      self[:date].to_s
    end

    def check_if_order_paid
      self.order.update(process_comments: self.payment_method.name)
      unless self.pending?
        points_payment_method = PaymentMethod.find_by(name: "Points")
        if Payment.where(order: self.order_id).sum(:amount_cents) >= self.order.amount_cents
          self.order.update(stage: "stage_paid", payment_status: "paid")
          add_points(self.order) unless self.payment_method_id == points_payment_method.id #do not add points for points payments
        end
      end
    end

    def add_points(order)
      user = order.user
      current_points = user.points
      Payment.transaction do
        user.update(points: current_points + order.amount_cents)
        PointsTransaction.create(user_id: user.id, points: (order.amount_cents / 100).floor, tx_type: 'purchase', tx_id: order.id)
      end
    end

    def new_culqi_payment(current_user, card_token_data, payment_amount, currency, payment_type, order_id = nil, payment_request_id = nil, device_finger_print_id = nil, authentication_3DS = nil)
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
      plain_mobile = current_user.username ? current_user.username.split(':')[0].gsub(/[^\d]/, '') : ( current_user.phone ? current_user.phone.split(':')[0].gsub(/[^\d]/, '') : "" )
      plain_mobile = plain_mobile[2..-1] if plain_mobile[0..1] == '51'
      antifraud_hash = no_antifraud_data ? nil : {
          :first_name => current_user.first_name,
          :last_name =>  current_user.last_name,
          :address => culqi_address,
          :address_city => "LIMA",
          :country_code => "PE",
          :phone_number => plain_mobile.blank? ? "986976377" : plain_mobile,
          :device_finger_print_id => device_finger_print_id
      }
      Rails.logger.debug "Antifraud Hash: #{antifraud_hash}"
      charge, statusCode = Culqi::Charge.create(
      :first_name => current_user.first_name,
      :last_name => current_user.last_name,
      :phone_number => current_user.phone || "986976377",
      :amount => payment_amount.to_i,
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
      :source_id => card_token_data.processor_token,
      :authentication_3DS => authentication_3DS
      )
      Rails.logger.debug ('charge response from Culqi::Charge Create: ' + charge.inspect)
      Rails.logger.debug ('statusCode response from Culqi::Charge Create: ' + statusCode.inspect)
      
      response = JSON.parse(charge)
      
      if statusCode == 200 && response["action_code"] == "REVIEW"

        #send back response so 3DS library will show 3DS flow and payment resent
        success = false
        return success, "3DS_FLOW_REQUIRED"

      else

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

    end

    def new_pagoefectrivo_payment(current_user, culqi_order_id, payment_amount, currency, payment_type, order_id = nil, payment_request_id = nil)
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
        new_payment.amount_cents = payment_amount
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
