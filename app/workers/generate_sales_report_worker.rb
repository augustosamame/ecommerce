# app/workers/generate_sales_report_worker.rb
class GenerateSalesReportWorker
  include Sidekiq::Worker

  def perform(start_date, email)
    begin
      Money.add_rate("USD", "PEN", 3.8)
      Money.add_rate("PEN", "USD", 1 / 3.8)
    rescue => e
      Rails.logger.error "Error setting up money exchange rates: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
      return
    end

    begin
      @orders = Ecommerce::Order.includes(:user, :order_items)
                                .where(payment_status: 1)
                                .where("ecommerce_orders.created_at >= ?", start_date.to_date)
                                .order(id: :desc)
    rescue => e
      Rails.logger.error "Error fetching orders: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
      return
    end

    p = Axlsx::Package.new
    wb = p.workbook
    wb.add_worksheet(name: "Exported Orders") do |sheet|
      sheet.add_row ["Order Id", "date_time", "user", "user email", "user phone", "Order Amount", "total_discount", "district", "efact", "coupon", "payment_status", "payment_method", "special_instructions", "status", "product_id", "product_name", "product_price", "product_quantity", "products_total", "cross_selling_item?"]
      
      @orders.find_each do |order|
        begin
          total_order_items_amount = order.order_items.sum { |item| item.price * item.quantity }
          order.order_items.each do |order_item|
            begin
              sheet.add_row [
                order.id,
                order.created_at - 5.hours,
                order.user.name,
                order.user.email,
                order.user.username.gsub('+51', ''),
                ActionController::Base.helpers.number_to_currency(order.amount, unit: "USD"),
                total_order_items_amount.to_f - order.amount.to_f,
                order.shipping_address.try(:district),
                order.efact_type,
                order.coupon.try(:coupon_code),
                order.paid? ? 'Pagada' : 'NO PAGADA',
                order.process_comments,
                order.delivery_comments,
                order.status,
                order_item.product_id,
                order_item.product.name,
                ActionController::Base.helpers.number_to_currency(order_item.price, unit: "USD"),
                order_item.quantity,
                ActionController::Base.helpers.number_to_currency(order_item.price * order_item.quantity, unit: "USD"),
                order_item.pre_checkout
              ]
            rescue Money::Bank::UnknownRate => e
              Rails.logger.error "Currency conversion error for order item ID #{order_item.id}: #{e.message}"
              Rails.logger.error order_item.inspect
            rescue => e
              Rails.logger.error "Error processing order item ID #{order_item.id}: #{e.message}"
              Rails.logger.error order_item.inspect
            end
          end
        rescue => e
          Rails.logger.error "Error processing order ID #{order.id}: #{e.message}"
          Rails.logger.error order.inspect
        end
      end
    end

    begin
      file = Tempfile.new(['orders', '.xlsx'], encoding: 'utf-8')
      p.serialize(file.path)

      AdminMailer.sales_report_email(email, file.path).deliver_now

      file.close
      file.unlink
    rescue => e
      Rails.logger.error "Error generating or sending the Excel file: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
    end
  end
end
