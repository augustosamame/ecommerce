module Ecommerce
  class Order < ApplicationRecord

    belongs_to :user
    belongs_to :cart, optional: true
    has_many :order_items, inverse_of: :order, dependent: :destroy
    accepts_nested_attributes_for :order_items, reject_if: :all_blank, allow_destroy: true
    belongs_to :coupon, optional: true

    enum stage: {stage_new: 0, stage_paid: 1, stage_shipped: 2, stage_delivered: 3, stage_closed: 4, stage_void: 5 }
    enum payment_status: {unpaid: 0, paid: 1, refunded: 2, payment_void: 3 }
    enum status: {active: 0, void: 2 }
    enum efact_type: {boleta: 0, factura: 1 }

    monetize :amount_cents, :shipping_amount_cents, :discount_amount_cents, with_model_currency: :currency

    after_commit :notify_new_order, on: :create
    after_commit :blank_user_carts, on: :create
    after_commit :fire_einvoice_worker, on: [:create, :update], if: :saved_change_to_payment_status?
    after_commit :set_stock_and_stage, on: [:create, :update], if: :saved_change_to_payment_status?

    attr_accessor :product_line_1, :product_line_2, :product_line_3, :product_line_4

    def notify_new_order
      SendOrderEmailsWorker.perform_in(30.seconds, self.id)
    end

    def blank_user_carts
      Cart.where(user_id: self.user).destroy_all
    end

    def fire_einvoice_worker
      CreateEinvoiceWorker.perform_async(self.id) unless self.payment_status == "unpaid"
    end

    def set_stock_and_stage
      if self.payment_status == "paid"
        self.update_columns(stage: "stage_paid") if self.stage == "stage_new"
        self.order_items.where(status: "active").each do |ol|
          ol.product.update(total_quantity: ol.product.total_quantity -= ol.quantity)
        end
      end
    end

    def friendly_stage
      I18n.translate("model.order.#{self.stage}")
    end

    def friendly_shipping_address
      found = Address.find_by(id: self.shipping_address_id)
      "#{found.try(:name)} - #{found.try(:street)} - #{found.try(:district)}"
    end

    def friendly_billing_address
      found = Address.find_by(id: self.billing_address_id)
      "#{found.try(:name)} - #{found.try(:street)} - #{found.try(:district)}"
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
      line = 0
      total_order_amount = (self.amount).to_f
      discount_total = (self.discount_amount).to_f.abs
      #since igv amount is taken by certifact as the sum of igv lines, the igv in tax lines need to be reduced based on the discount
      OrderItem.where(order_id: self.id).includes(:product).each do |item|
        invoice_lines_array << {name: item.product.name, quantity: item.quantity, product_id: item.product.id, price_total: (item.price * item.quantity).to_f, price_subtotal: item.price.to_f }
        igv_found = item.product.product_taxes.find_by(tax_id: Ecommerce::Tax.first.try(:id))
        if igv_found
          invoice_lines_array[line][:igv_tax] = true
          invoice_lines_array[line][:igv_amount] = igv_found.try(:tax_amount)
        else
          invoice_lines_array[line][:igv_tax] = false
          invoice_lines_array[line][:igv_amount] = 0
        end
        isc_found = item.product.product_taxes.find_by(tax_id: Ecommerce::Tax.second.try(:id))
        if isc_found
          invoice_lines_array[line][:isc_tax] = true
          invoice_lines_array[line][:isc_amount] = isc_found.try(:tax_amount)
        else
          invoice_lines_array[line][:isc_tax] = false
          invoice_lines_array[line][:isc_amount] = 0
        end
        line +=1
      end
      if self.shipping_amount_cents > 0
        invoice_lines_array << {name: "Costo de envío (shipping)", quantity: 1, product_id: 1000, price_total: shipping_amount.to_i, price_subtotal: shipping_amount.to_i, igv_tax: true, igv_amount: 18 }
      end

      case self.payment_status
        when "paid"
          return false if efact_number
          case self.efact_type
            when "boleta"
              invoice_hash = {
                einvoice_type: "boleta",
                number: "B#{Ecommerce.serie_boleta}-#{Ecommerce::Control.find_by!(name: "next_boleta_number").integer_value}",
                currency_id: "USD",
                id: self.id,
                zip: "030101",
                catalog_06_id: "1 - DNI",
                partner_id: "#{self.user.first_name} #{self.user.last_name}",
                company_id: Ecommerce.company_legal_name,
                email: self.user.email,
                vat: self.amount.to_i >= 210 ? self.required_doc : "",
                street: order_billing_address.try(:street),
                company_id_city: Ecommerce.company_city,
                company_id_street: Ecommerce.company_street,
                date_invoice: Time.now.to_s[0..9],
                payment_term_id: "Contado",
                date: Time.now.to_s[0..9],
                amount_total: total_order_amount,
                discount_total: discount_total,
                company_id_zip: 33,
                partner_shipping_id: "shipping_id",
                company_id_vat: Ecommerce.company_vat,
                district_id: order_billing_address.try(:district),
                province_id: order_billing_address.try(:city),
                state_id: order_billing_address.try(:state),
                invoice_line_ids: invoice_lines_array
              }
              correlativo_to_update_on_200 = Ecommerce::Control.find_by!(name: "next_boleta_number")
            when "factura"
              invoice_hash = {
                einvoice_type: "factura",
                number: "F#{Ecommerce.serie_factura}-#{Ecommerce::Control.find_by!(name: "next_factura_number").integer_value}",
                currency_id: "USD",
                id: self.id,
                zip: "030101",
                catalog_06_id: "6 - RUC",
                partner_id: Ecommerce::DataBizInvoice.find_by(user_id: self.user.id).try(:razon_social),
                company_id: Ecommerce.company_legal_name,
                email: self.user.email,
                vat: Ecommerce::DataBizInvoice.find_by(user_id: self.user.id).try(:vat),
                street: Ecommerce::DataBizInvoice.find_by(user_id: self.user.id).try(:address),
                company_id_city: Ecommerce.company_city,
                company_id_street: Ecommerce.company_street,
                date_invoice: Time.now.to_s[0..9],
                payment_term_id: "Contado",
                date: Time.now.to_s[0..9],
                amount_total: total_order_amount,
                discount_total: discount_total,
                company_id_zip: 33,
                partner_shipping_id: "shipping_id",
                company_id_vat: Ecommerce.company_vat,
                district_id: "",
                province_id: Ecommerce::DataBizInvoice.find_by(user_id: self.user.id).try(:city),
                state_id: Ecommerce::DataBizInvoice.find_by(user_id: self.user.id).try(:city),
                invoice_line_ids: invoice_lines_array
              }
              correlativo_to_update_on_200 = Ecommerce::Control.find_by!(name: "next_factura_number")
          end
        when "refunded"
          return false if !efact_number || efact_refund_number
          case self.efact_number[0]
            when "B"
              invoice_hash = {
                einvoice_type: "nota_de_credito",
                number: "B#{Ecommerce.serie_nota_de_credito}-#{Ecommerce::Control.find_by!(name: "next_nota_de_credito_boleta_number").integer_value}",
                affected_document: self.efact_number,
                currency_id: "USD",
                id: self.id,
                zip: "030101",
                catalog_06_id: "1 - DNI",
                partner_id: "#{self.user.first_name} #{self.user.last_name}",
                company_id: Ecommerce.company_legal_name,
                email: self.user.email,
                vat: self.amount.to_i >= 210 ? self.required_doc : "",
                street: order_billing_address.try(:street),
                company_id_city: Ecommerce.company_city,
                company_id_street: Ecommerce.company_street,
                date_invoice: Time.now.to_s[0..9],
                payment_term_id: "Contado",
                date: Time.now.to_s[0..9],
                amount_total: total_order_amount,
                company_id_zip: 33,
                partner_shipping_id: "shipping_id",
                company_id_vat: Ecommerce.company_vat,
                district_id: order_billing_address.try(:district),
                province_id: order_billing_address.try(:city),
                state_id: order_billing_address.try(:state),
                invoice_line_ids: invoice_lines_array
              }
              correlativo_to_update_on_200 = Ecommerce::Control.find_by!(name: "next_nota_de_credito_boleta_number")
            when "F"
              invoice_hash = {
                einvoice_type: "nota_de_credito",
                number: "F#{Ecommerce.serie_nota_de_credito}-#{Ecommerce::Control.find_by!(name: "next_nota_de_credito_factura_number").integer_value}",
                affected_document: self.efact_number,
                currency_id: "USD",
                id: self.id,
                zip: "030101",
                catalog_06_id: "6 - RUC",
                partner_id: Ecommerce::DataBizInvoice.find_by(user_id: self.user.id).try(:razon_social),
                company_id: Ecommerce.company_legal_name,
                email: self.user.email,
                vat: Ecommerce::DataBizInvoice.find_by(user_id: self.user.id).try(:vat),
                street: Ecommerce::DataBizInvoice.find_by(user_id: self.user.id).try(:address),
                company_id_city: Ecommerce.company_city,
                company_id_street: Ecommerce.company_street,
                date_invoice: Time.now.to_s[0..9],
                payment_term_id: "Contado",
                date: Time.now.to_s[0..9],
                amount_total: total_order_amount,
                company_id_zip: 33,
                partner_shipping_id: "shipping_id",
                company_id_vat: Ecommerce.company_vat,
                district_id: "",
                province_id: Ecommerce::DataBizInvoice.find_by(user_id: self.user.id).try(:city),
                state_id: Ecommerce::DataBizInvoice.find_by(user_id: self.user.id).try(:city),
                invoice_line_ids: invoice_lines_array
              }
              correlativo_to_update_on_200 = Ecommerce::Control.find_by!(name: "next_nota_de_credito_factura_number")
          end
        when "payment_void"
          return false if !efact_number
          invoice_hash = {
            einvoice_type: "anulacion",
            affected_document: self.efact_number,
            void_reason: "Cancelación"
          }
        else
          invoice_hash = {
            error: "invoice is unpaid"
          }
      end

      url = URI(Ecommerce::Control.find_by(name: 'efact_url').text_value)
      puts "invoice_hash: #{invoice_hash.to_json} sent to #{url}"
      Rails.logger.debug "invoice_hash: #{invoice_hash.to_json} sent to #{url}"
      http = Net::HTTP.new(url.host, url.port)
      http.use_ssl = true if url.scheme == "https"
      request = Net::HTTP::Post.new(url)
      request["Content-Type"] = 'application/json'
      #TODO add type of authentication field in backoffice to support Bearer Token
      request["Authorization"] = "Bearer #{Ecommerce::Control.find_by!(name: "efact_token").text_value}"
      request["Cache-Control"] = 'no-cache'
      request.body = invoice_hash.to_json
      self.update_columns(efact_sent_text: invoice_hash.to_json)
      response = http.request(request)
      if response.code == "200"
        response_body = JSON.parse(response.read_body)
        if response.read_body && response_body["response_text"] == "OK"
          case invoice_hash[:einvoice_type]
            when "nota_de_credito"
              self.update_columns(efact_response_text: "OK", efact_refund_url: response_body["response_url"], efact_refund_number: invoice_hash[:number] )
            when "anulacion"
              self.update_columns(efact_response_text: "OK", efact_void_url: response_body["response_url"] )
            else
              self.update_columns(efact_response_text: "OK", efact_invoice_url: response_body["response_url"], efact_number: invoice_hash[:number] )
          end
          correlativo_to_update_on_200.update_columns(integer_value: correlativo_to_update_on_200.integer_value + 1) if correlativo_to_update_on_200
        else
          self.update_columns(efact_response_text: "Internal Error #{response.code} - #{response_body["response_text"]}")
          AdminMailer.einvoice_error_email(self).deliver! #unless Rails.env == "development"
        end
        return response_body.to_json
      else
        self.update_columns(efact_response_text: "Internal Error #{response.code}")
        AdminMailer.einvoice_error_email(self).deliver! #unless Rails.env == "development"
        return response.read_body
      end
    end

  end
end
