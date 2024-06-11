# app/workers/generate_sales_report_worker.rb
class GenerateSalesReportWorker
  include Sidekiq::Worker

  def perform(start_date, email)
    @orders = Ecommerce::Order.includes(:user, :order_items)
                              .where(payment_status: 1)
                              .where("ecommerce_orders.created_at >= ?", start_date.to_date)
                              .order(id: :desc)

    p = Axlsx::Package.new
    wb = p.workbook
    wb.add_worksheet(name: "Exported Orders") do |sheet|
      sheet.add_row ["Order Id", "date_time", "user", "user email", "user phone", "Order Amount", "total_discount", "district", "efact", "coupon", "payment_status", "payment_method", "special_instructions", "status", "product_id", "product_name", "product_price", "product_quantity", "products_total", "cross_selling_item?"]
      @orders.find_each do |order|
        total_order_items_amount = order.order_items.sum { |item| item.price * item.quantity }
        order.order_items.each do |order_item|
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
        end
      end
    end

    file = Tempfile.new(['orders', '.xlsx'], encoding: 'utf-8')
    p.serialize(file.path)

    AdminMailer.sales_report_email(email, file.path).deliver_now

    file.close
    file.unlink
  end
end
