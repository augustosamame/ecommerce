module Ecommerce
  class Order < ApplicationRecord

    paginates_per 200

    belongs_to :user
    belongs_to :cart, optional: true
    has_many :order_items, inverse_of: :order, dependent: :destroy
    accepts_nested_attributes_for :order_items, reject_if: :all_blank, allow_destroy: true
    belongs_to :coupon, optional: true

    enum stage: {stage_new: 0, stage_paid: 1, stage_shipped: 2, stage_delivered: 3, stage_closed: 4, stage_void: 5, stage_pending: 6 }
    enum payment_status: {unpaid: 0, paid: 1, refunded: 2, payment_void: 3 }
    enum status: {active: 0, void: 2 }
    enum efact_type: {boleta: 0, factura: 1 }

    monetize :amount_cents, :shipping_amount_cents, :discount_amount_cents, with_model_currency: :currency

    #after_commit :notify_new_order, on: :create
    #after_commit :blank_user_carts, on: :create
    #after_commit :notify_unpaid_to_paid, on: :update, if: :saved_change_to_payment_status
    after_commit :fire_einvoice_worker, on: [:create, :update], if: :saved_change_to_payment_status?
    #after_commit :set_stock_and_stage, on: [:create, :update], if: :saved_change_to_payment_status?

    attr_accessor :product_line_1, :product_line_2, :product_line_3, :product_line_4

    def notify_new_order
      SendOrderEmailsWorker.perform_in(30.seconds, self.id)
      #TwilioIntegration.new.send_sms_to_number("A new Order ##{self.id} has been placed", '51989080023') if Rails.env == "production"
      SlackIntegration.new.send_slack_to_channel("A new Order ##{self.id} has been placed: https://expatshop.pe/store/backoffice/orders/#{self.id}", "#store-orders")
    end

    def blank_user_carts
      Cart.where(user_id: self.user).destroy_all
    end

    def fire_einvoice_worker
      CreateEinvoiceWorker.perform_async(self.id) unless self.payment_status == "unpaid"
    end

    def notify_unpaid_to_paid
      SendUnpaidToPaidEmailsWorker.perform_async(self.id) if self.payment_status == "paid" && Time.now > (self.created_at + 1.minute)
    end

    def set_stock_and_stage
      if self.payment_status == "paid"
        self.update_columns(stage: "stage_paid") if self.stage == "stage_new"
        self.order_items.where(status: "active").each do |ol|
          ol.product.update(total_quantity: ol.product.total_quantity -= ol.quantity)
        end
        #TwilioIntegration.new.send_sms_to_user("Your ExpatShop Order No. #{self.id} has been Paid! We will let you know when we ship.", self.user.id) if Rails.env == "production"
        Campaign.send_recipients(self.id)
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

    def smart_date_invoice
      if (Time.now - 5.hours).hour < 8
        return (Time.now - 5.hours - 1.day).to_s[0..9]
      else
        return (Time.now - 5.hours).to_s[0..9]
      end
    end

    def generate_user_address_order_woocommerce(payload)
      user = User.find_by(email: payload[:user][:email])
      unless user
        user = User.find_by(phone: payload[:user][:phone])
      end
      unless user
        user = User.create!(
          email: payload[:user][:email],
          first_name: payload[:user][:first_name],
          last_name: payload[:user][:last_name],
          role: 'standard',
          password: '12345678',
          phone: payload[:user][:phone],
          username: payload[:user][:phone],
          address: "#{payload[:order][:shipping_addres][:address_1]}, #{payload[:order][:shipping_addres][:city]}, #{payload[:order][:shipping_addres][:state]}",
          status: 'regular')
      end
      new_order = Order.create!(
        user_id: user.id,
        #woocommerce_order_number: payload[:order][:order_number],
        amount_cents: ((payload[:order][:amount].to_f)*100).to_i,
        shipping_amount_cents: ((payload[:order][:shipping_amount].to_f)*100).to_i,
        stage: 'stage_paid',
        payment_status: 'paid',
        status: 'active',
        efact_type: payload[:user][:document_type] == 'boleta' ? 'boleta' : 'factura',
        customer_comments: payload[:order][:order_comments],
        currency: payload[:order][:currency],
        discount_amount_cents: ((payload[:order][:discount_amount].to_f)*100).to_i
      )
      if new_order.persisted?
        list_of_products = payload[:order][:products]
        brand_id = Brand.first.id
        supplier_id = Supplier.first.id
        list_of_products.each do |product|
          new_product = Product.create!(
            brand_id: brand_id,
            supplier_id: supplier_id,
            name: product[:name],
            price_cents: ((product[:product_price].to_f)*100).to_i,
            description: product[:product_description],
            short_description: product[:product_description],
            category_list: ["Default"],
            weight: 0
          )
          OrderItem.create!(
            order_id: new_order.id,
            product_id: new_product.id,
            currency: payload[:order][:currency],
            status: 'active',
            price_cents: ((product[:product_price].to_f)*100).to_i,
            quantity: product[:quantity],
          )
        end
        new_address_shipping = Address.create!(
          user_id: user.id,
          street: payload[:order][:shipping_addres][:address_1],
          street2: payload[:order][:shipping_addres][:address_2],
          district: payload[:order][:shipping_addres][:city],
          city: payload[:order][:shipping_addres][:state],
          state: 'Lima',
          address_type: 'home',
          shipping_or_billing: 'shipping'
        )
        new_address_billing = Address.create!(
          user_id: user.id,
          street: payload[:order][:billing_addres][:address_1],
          street2: payload[:order][:billing_addres][:address_2],
          district: payload[:order][:billing_addres][:city],
          city: payload[:order][:billing_addres][:state],
          state: 'Lima',
          address_type: 'home',
          shipping_or_billing: 'billing'
        )
        new_order.update_columns(billing_address_id: new_address_billing.id, shipping_address_id: new_address_shipping.id)
      end
      new_einvoice_data = new_order.generate_einvoice
      return new_einvoice_data
    end


    def generate_einvoice
      order_billing_address = Address.find_by(id: self.billing_address_id)
      invoice_lines_array = Array.new
      line = 0
      weight = 0.0
      total_order_amount = (self.amount).to_f - (self.points_redeemed_amount.to_f / 100)
      discount_total = ((self.discount_amount).to_f.abs + (self.points_redeemed_amount.to_f / 100)) / 1.18
      #since igv amount is taken by certifact as the sum of igv lines, the igv in tax lines need to be reduced based on the discount
      OrderItem.where(order_id: self.id).includes(:product).each do |item|
        invoice_lines_array << {name: item.product.name, quantity: item.quantity, product_id: item.product.id, price_total: (item.price * item.quantity).to_f, price_subtotal: item.price.to_f, weight: (item.quantity * item.product.weight).to_f }
        igv_found = item.product.product_taxes.find_by(tax_id: Ecommerce::Tax.first.try(:id))
        weight += (item.quantity * item.product.weight).to_f
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
                catalog_06_id: (self.required_doc.blank? || self.required_doc.try(:strip).try(:length) == 8) ? "1 - DNI" : "4 - CARNET DE EXTRANJERIA",
                partner_id: "#{self.user.first_name} #{self.user.last_name} (#{self.user.username})",
                company_id: Ecommerce.company_legal_name,
                email: self.user.email,
                vat: self.amount.to_i >= 210 ? self.required_doc : "",
                company_id_city: Ecommerce.company_city,
                company_id_street: Ecommerce.company_street,
                date_invoice: smart_date_invoice,
                payment_term_id: "Contado",
                date: smart_date_invoice,
                amount_total: total_order_amount,
                discount_total: discount_total,
                weight: weight,
                observation: self.delivery_comments,
                company_id_zip: 33,
                partner_shipping_id: "shipping_id",
                company_id_vat: Ecommerce.company_vat,
                street: order_billing_address.try(:street),
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
                partner_id: Ecommerce::DataBizInvoice.find_by(user_id: self.user.id).try(:razon_social) + " (#{self.user.username})",
                company_id: Ecommerce.company_legal_name,
                email: self.user.email,
                vat: Ecommerce::DataBizInvoice.find_by(user_id: self.user.id).try(:vat),
                company_id_city: Ecommerce.company_city,
                company_id_street: Ecommerce.company_street,
                date_invoice: smart_date_invoice,
                payment_term_id: "Contado",
                date: smart_date_invoice,
                amount_total: total_order_amount,
                discount_total: discount_total,
                weight: weight,
                observation: self.delivery_comments,
                company_id_zip: 33,
                partner_shipping_id: "shipping_id",
                company_id_vat: Ecommerce.company_vat,
                street: order_billing_address.try(:street),
                district_id: order_billing_address.try(:district),
                province_id: order_billing_address.try(:city),
                state_id: order_billing_address.try(:state),
                street_razon_social: Ecommerce::DataBizInvoice.find_by(user_id: self.user.id).try(:address),
                district_id_razon_social: "",
                province_id_razon_social: Ecommerce::DataBizInvoice.find_by(user_id: self.user.id).try(:city),
                state_id_razon_social: Ecommerce::DataBizInvoice.find_by(user_id: self.user.id).try(:city),
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
                catalog_06_id: (self.required_doc.blank? || self.required_doc.try(:strip).try(:length) == 8) ? "1 - DNI" : "4 - CARNET DE EXTRANJERIA",
                partner_id: "#{self.user.first_name} #{self.user.last_name}",
                company_id: Ecommerce.company_legal_name,
                email: self.user.email,
                vat: self.amount.to_i >= 210 ? self.required_doc : "",
                company_id_city: Ecommerce.company_city,
                company_id_street: Ecommerce.company_street,
                date_invoice: smart_date_invoice,
                payment_term_id: "Contado",
                date: smart_date_invoice,
                amount_total: total_order_amount,
                company_id_zip: 33,
                partner_shipping_id: "shipping_id",
                company_id_vat: Ecommerce.company_vat,
                street: order_billing_address.try(:street),
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
                company_id_city: Ecommerce.company_city,
                company_id_street: Ecommerce.company_street,
                date_invoice: smart_date_invoice,
                payment_term_id: "Contado",
                date: smart_date_invoice,
                amount_total: total_order_amount,
                company_id_zip: 33,
                partner_shipping_id: "shipping_id",
                company_id_vat: Ecommerce.company_vat,
                street: order_billing_address.try(:street),
                district_id: order_billing_address.try(:district),
                province_id: order_billing_address.try(:city),
                state_id: order_billing_address.try(:state),
                street_razon_social: Ecommerce::DataBizInvoice.find_by(user_id: self.user.id).try(:address),
                district_id_razon_social: "",
                province_id_razon_social: Ecommerce::DataBizInvoice.find_by(user_id: self.user.id).try(:city),
                state_id_razon_social: Ecommerce::DataBizInvoice.find_by(user_id: self.user.id).try(:city),
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

    def clear_einvoice
      self.efact_sent_text = nil
      self.efact_response_text = nil
      self.efact_invoice_url = nil
      self.efact_number = nil
      self.efact_void_url = nil
      self.save
    end

    def generate_einvoice_from_woocommerce(payload)
      return {einvoice_number: rand(1..100).to_s.rjust(8, "0") }
      invoice_lines_array = Array.new
      line = 0
      weight = 0.0
      total_order_amount = (self.amount).to_f - (self.points_redeemed_amount.to_f / 100)
      discount_total = ((self.discount_amount).to_f.abs + (self.points_redeemed_amount.to_f / 100)) / 1.18
      #since igv amount is taken by certifact as the sum of igv lines, the igv in tax lines need to be reduced based on the discount
      OrderItem.where(order_id: self.id).includes(:product).each do |item|
        invoice_lines_array << {name: item.product.name, quantity: item.quantity, product_id: item.product.id, price_total: (item.price * item.quantity).to_f, price_subtotal: item.price.to_f, weight: (item.quantity * item.product.weight).to_f }
        igv_found = item.product.product_taxes.find_by(tax_id: Ecommerce::Tax.first.try(:id))
        weight += (item.quantity * item.product.weight).to_f
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
                catalog_06_id: (self.required_doc.blank? || self.required_doc.try(:strip).try(:length) == 8) ? "1 - DNI" : "4 - CARNET DE EXTRANJERIA",
                partner_id: "#{self.user.first_name} #{self.user.last_name} (#{self.user.username})",
                company_id: Ecommerce.company_legal_name,
                email: self.user.email,
                vat: self.amount.to_i >= 210 ? self.required_doc : "",
                company_id_city: Ecommerce.company_city,
                company_id_street: Ecommerce.company_street,
                date_invoice: smart_date_invoice,
                payment_term_id: "Contado",
                date: smart_date_invoice,
                amount_total: total_order_amount,
                discount_total: discount_total,
                weight: weight,
                observation: self.delivery_comments,
                company_id_zip: 33,
                partner_shipping_id: "shipping_id",
                company_id_vat: Ecommerce.company_vat,
                street: payload.try(:street),
                district_id: payload.try(:district),
                province_id: payload.try(:city),
                state_id: payload.try(:state),
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
                partner_id: Ecommerce::DataBizInvoice.find_by(user_id: self.user.id).try(:razon_social) + " (#{self.user.username})",
                company_id: Ecommerce.company_legal_name,
                email: self.user.email,
                vat: Ecommerce::DataBizInvoice.find_by(user_id: self.user.id).try(:vat),
                company_id_city: Ecommerce.company_city,
                company_id_street: Ecommerce.company_street,
                date_invoice: smart_date_invoice,
                payment_term_id: "Contado",
                date: smart_date_invoice,
                amount_total: total_order_amount,
                discount_total: discount_total,
                weight: weight,
                observation: self.delivery_comments,
                company_id_zip: 33,
                partner_shipping_id: "shipping_id",
                company_id_vat: Ecommerce.company_vat,
                street: payload.try(:street),
                district_id: payload.try(:district),
                province_id: payload.try(:city),
                state_id: payload.try(:state),
                street_razon_social: Ecommerce::DataBizInvoice.find_by(user_id: self.user.id).try(:address),
                district_id_razon_social: "",
                province_id_razon_social: Ecommerce::DataBizInvoice.find_by(user_id: self.user.id).try(:city),
                state_id_razon_social: Ecommerce::DataBizInvoice.find_by(user_id: self.user.id).try(:city),
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
                catalog_06_id: (self.required_doc.blank? || self.required_doc.try(:strip).try(:length) == 8) ? "1 - DNI" : "4 - CARNET DE EXTRANJERIA",
                partner_id: "#{self.user.first_name} #{self.user.last_name}",
                company_id: Ecommerce.company_legal_name,
                email: self.user.email,
                vat: self.amount.to_i >= 210 ? self.required_doc : "",
                company_id_city: Ecommerce.company_city,
                company_id_street: Ecommerce.company_street,
                date_invoice: smart_date_invoice,
                payment_term_id: "Contado",
                date: smart_date_invoice,
                amount_total: total_order_amount,
                company_id_zip: 33,
                partner_shipping_id: "shipping_id",
                company_id_vat: Ecommerce.company_vat,
                street: payload.try(:street),
                district_id: payload.try(:district),
                province_id: payload.try(:city),
                state_id: payload.try(:state),
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
                company_id_city: Ecommerce.company_city,
                company_id_street: Ecommerce.company_street,
                date_invoice: smart_date_invoice,
                payment_term_id: "Contado",
                date: smart_date_invoice,
                amount_total: total_order_amount,
                company_id_zip: 33,
                partner_shipping_id: "shipping_id",
                company_id_vat: Ecommerce.company_vat,
                street: payload.try(:street),
                district_id: payload.try(:district),
                province_id: payload.try(:city),
                state_id: payload.try(:state),
                street_razon_social: Ecommerce::DataBizInvoice.find_by(user_id: self.user.id).try(:address),
                district_id_razon_social: "",
                province_id_razon_social: Ecommerce::DataBizInvoice.find_by(user_id: self.user.id).try(:city),
                state_id_razon_social: Ecommerce::DataBizInvoice.find_by(user_id: self.user.id).try(:city),
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
