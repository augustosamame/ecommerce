module Ecommerce
  class Order < ApplicationRecord

    belongs_to :user
    belongs_to :cart
    has_many :order_items

    enum stage: {stage_new: 0, stage_paid: 1, stage_shipped: 2, stage_delivered: 3, stage_closed: 4, stage_void: 5 }
    enum payment_status: {unpaid: 0, paid: 1, refunded: 2 }
    enum status: {active: 0, void: 2 }

    def friendly_stage
      I18n.translate("model.order.#{self.stage}")
    end

    def friendly_shipping_address
      found = Address.find_by(id: self.shipping_address_id)
      "#{found.name} - #{found.street} - #{found.district}"
    end

    def friendly_billing_address
      found = Address.find_by(id: self.billing_address_id)
      "#{found.name} - #{found.street} - #{found.district}"
    end

    def shipping_address
      Address.find_by(id: self.shipping_address_id)
    end

    def billing_address
      Address.find_by(id: self.billing_address_id)
    end

    def generate_einvoice
      order_billing_address = Address.find_by(id: self.billing_address_id)
      invoice_lines_array = Array.new
      OrderItem.where(order_id: self.id).includes(:product).each do |item|
        invoice_lines_array << {name: item.product.name, quantity: item.quantity, product_id: item.product.id, price_total: item.price_cents / 100, price_subtotal: ((item.price_cents / 1.18).to_i) / 100 }
      end
      invoice_hash = {
        number: "B001-#{127 + self.id}",
        currency_id: "PEN",
        id: self.id,
        zip: "030101",
        catalog_06_id: "1 - DNI",
        partner_id: Ecommerce.company_legal_name,
        company_id: Ecommerce.company_legal_name,
        email: self.user.email,
        vat: "09344556",
        street: order_billing_address.try(:street),
        company_id_city: Ecommerce.company_city,
        company_id_street: Ecommerce.company_street,
        date_invoice: Time.now.to_s[0..9],
        payment_term_id: "Contado",
        date: Time.now.to_s[0..9],
        amount_total: self.amount_cents / 100,
        company_id_zip: 33,
        partner_shipping_id: "shipping_id",
        company_id_vat: Ecommerce.company_vat,
        district_id: order_billing_address.try(:district),
        province_id: order_billing_address.try(:city),
        state_id: order_billing_address.try(:state),
        invoice_line_ids: invoice_lines_array
      }
      url = URI(ENV['DEVTECH_EFACT_ENDPOINT'])
      http = Net::HTTP.new(url.host, url.port)
      request = Net::HTTP::Post.new(url)
      request["Content-Type"] = 'application/json'
      request["authorization"] = ENV['DEVTECH_EFACT_TOKEN']
      request["Cache-Control"] = 'no-cache'
      request.body = invoice_hash.to_json
      response = http.request(request)
      if response.code == "200"
        response_body = JSON.parse(response.read_body)
        if response.read_body && response_body["response_text"] == "OK"
          self.update_columns(efact_response_text: "OK", efact_invoice_url: response_body["response_url"], efact_sent_text: invoice_hash.to_json)
          TwilioIntegration.new.send_sms_to_number("Your ExpatShop Order No. #{self.id} has been Paid! We will let you know when we ship.", self.user.username) #if Rails.env == "production"
        else
          self.update_columns(efact_response_text: "Internal Error #{response.code} - #{response_body["response_text"]}")
        end
        return response_body.to_json
      else
        self.update_columns(efact_response_text: "Internal Error #{response.code}")
        return response.read_body
      end
    end

  end
end
