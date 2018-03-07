module Ecommerce
  class Order < ApplicationRecord
    belongs_to :user
    belongs_to :cart

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

    def einvoice
      invoice_hash = {
        number: "B001-#{100 + 1}",
        currency_id: "PEN",
        id: self.id,
        province_id: "ABANCAY",
        zip: "030101",
        catalog_06_id: "6 - RUC",
        company_id: "ORGANIZACION EL CONSTRUCTOR SAC",
        email: self.user.email,
        vat: "20602903312",
        street: "AV. CHILE NRO. 111 (ESQ CN VENEZUELA CT MADERERA PALOMINO) APURIMAC",
        company_id_city: "Andahuaylas",
        company_id_street: "Av. Perú No. 140",
        date_invoice: self.created_at,
        payment_term_id: "15 Days",
        date: Time.now.to_s[0..9],
        amount_total: self.amount_cents / 100,
        company_id_zip: false,
        partner_shipping_id: "CONSTRUCTORA Y CONSULTORA JCN",
        company_id_vat: "20602903312",
        district_id: "ABANCAY",
        state_id: "APURIMAC"
      }
      url = URI("http://localhost:3001/invoice")
      http = Net::HTTP.new(url.host, url.port)
      request = Net::HTTP::Post.new(url)
      request["Content-Type"] = 'application/json'
      request["authorization"] = '12345678901234566251'
      request["Cache-Control"] = 'no-cache'
      request.body = invoice_hash.to_json

      response = http.request(request)
      puts response.read_body
      byebug
    end

  end
end
