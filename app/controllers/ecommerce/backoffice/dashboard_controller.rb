module Ecommerce
  class Backoffice::DashboardController < Backoffice::BaseController

    authorize_resource :class => false

    def main
      @last_users = User.where(role: "standard").order(id: :desc).first(10)
      @last_orders = Order.includes(:user).order(id: :desc).first(10)
    end

    def export_products
      @products = Ecommerce::Product.all.order(id: :desc)

      respond_to do |format|

        format.html {
          p = Axlsx::Package.new
          wb = p.workbook
          wb.add_worksheet(:name => "Exported Products") do |sheet|
            sheet.add_row ["id","category_id","brand_id","supplier_id","image", "permalink","price_cents","discounted_price_cents","meta_keywords","meta_description","stockable","home_featured","category_featured","available_at","deleted_at","created_at","updated_at","description2","product_order","stockable","total_quantity","status","usd_price_cents","usd_discounted_price_cents","coupon_id","name","short_description","description","category_list","tax_list (igv: 1, isc: 2)"]
            @products.each do |product|
              sheet.add_row [
                product.id, product.category_id, product.brand_id, product.supplier_id, product.image, product.permalink, product.price_cents, product.discounted_price_cents, product.meta_keywords, product.meta_description, product.stockable, product.home_featured, product.category_featured, product.available_at, product.deleted_at, product.created_at, product.updated_at, product.description2, product.product_order, product.stockable, product.total_quantity, product.status, product.usd_price_cents, product.usd_discounted_price_cents, product.coupon_id, product.name, product.short_description, product.description, product.category_list, product.product_taxes.pluck(:tax_id, :tax_amount).try(:to_s)
              ]
            end
          end
          send_data p.to_stream.read, :filename => 'products.xlsx', :type => "application/vnd.openxmlformates-officedocument.spreadsheetml.sheet"
        }

      end
    end

    def export_users
      @users = User.all.order(id: :desc)

      respond_to do |format|

        format.html {
          p = Axlsx::Package.new
          wb = p.workbook
          wb.add_worksheet(:name => "Exported Users") do |sheet|
            sheet.add_row ["id","email","first_name","last_name","phone", "doc_id"]
            @users.each do |user|
              sheet.add_row [
                user.id, user.email, user.first_name, user.last_name, user.username, user.doc_id
              ]
            end
          end
          send_data p.to_stream.read, :filename => 'users.xlsx', :type => "application/vnd.openxmlformates-officedocument.spreadsheetml.sheet"
        }

      end
    end

    def export_orders
      @orders = Order.all.order(id: :desc).page(params[:page])

      respond_to do |format|

        format.html {
          p = Axlsx::Package.new
          wb = p.workbook
          wb.add_worksheet(:name => "Exported Orders") do |sheet|
            sheet.add_row ["id","date_time", "user","amount","stage","efact", "shipping address", "phone", "coupon", "payment_status", "payment_method", "special_instructions", "status"]
            @orders.each do |order|
              sheet.add_row [
                order.id,
                order.created_at - 5.hours,
                order.user.name,
                ActionController::Base.helpers.number_to_currency(order.amount),
                order.friendly_stage,
                order.efact_type,
                order.friendly_shipping_address,
                order.user.username.gsub('+51',''),
                order.coupon.try(:coupon_code),
                order.paid? ? 'Pagada' : 'NO PAGADA',
                order.process_comments,
                order.delivery_comments,
                order.status
              ]
            end
          end
          send_data p.to_stream.read, :filename => 'orders.xlsx', :type => "application/vnd.openxmlformates-officedocument.spreadsheetml.sheet"
        }

      end
    end

  end
end
