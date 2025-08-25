module Ecommerce
  class Backoffice::DashboardController < Backoffice::BaseController
    before_action :redirect_drivers_to_recent_orders

    authorize_resource :class => false

    def main
      @last_users = User.where(role: "standard").order(id: :desc).first(10)
      @last_orders = Order.includes(:user).order(id: :desc).first(10)
    end

    def business_intelligence

    end

    
    def complete_sale_data
      email = params[:report][:email]
      start_date = params[:report][:start_date]

      GenerateSalesReportWorker.perform_async(start_date, email)

      redirect_to backoffice_business_intelligence_path, notice: 'The report is being generated and will be sent to your email shortly.'
    end


    def biz_top_buyers
      #@user_orders = User.joins(:orders).where(ecommerce_orders: { payment_status: 1 }).where("ecommerce_orders.created_at >= ?", params[:report][:start_date].to_date).select('users.*, COUNT(ecommerce_orders.id) as total_orders').group('users.id').order('total_orders DESC')

      @user_orders = User.joins(:orders)
                   .where(ecommerce_orders: { payment_status: 1 })
                   .where("ecommerce_orders.created_at >= ?", params[:report][:start_date].to_date)
                   .select('users.*, COUNT(ecommerce_orders.id) as total_orders, SUM(ecommerce_orders.amount_cents) as total_amount, AVG(ecommerce_orders.amount_cents) as avg_amount')
                   .group('users.id')
                   .order('total_orders DESC')

      respond_to do |format|

        format.html {
          p = Axlsx::Package.new
          wb = p.workbook
          wb.add_worksheet(:name => "Top Buyers since #{params[:report][:start_date].gsub("/", "-")}") do |sheet|
            sheet.add_row ["user_id", "email", "total_orders", "total_orders_amount", "orders_average", "sign_in_count", "last_sign_in_at", "first_name", "last_name", "phone", "username", "doc_id", "created_at", "points"]
            @user_orders.each do |user|
              sheet.add_row [
                user.id,
                user.email,
                user.total_orders,
                (user.total_amount.to_f / 100),
                (user.avg_amount.to_f / 100),
                user.sign_in_count,
                user.last_sign_in_at - 5.hours,
                user.first_name,
                user.last_name,
                user.phone,
                user.username,
                user.doc_id,
                user.created_at - 5.hours,
                user.points
              ]
            end
          end
          send_data p.to_stream.read, :filename => 'users.xlsx', :type => "application/vnd.openxmlformates-officedocument.spreadsheetml.sheet"
        }

      end
    end

    def biz_specific_product
      product = Ecommerce::Product.find(params[:report][:product])
      œuser_ids = Ecommerce::Order.includes(:user).where("ecommerce_orders.payment_status = ?", 1).where("ecommerce_orders.id IN (?)", Ecommerce::OrderItem.where(product_id: product.id).pluck(:order_id)).pluck(:user_id).uniq
      @users = User.where(id: œuser_ids)

      respond_to do |format|

        format.html {
          p = Axlsx::Package.new
          wb = p.workbook
          wb.add_worksheet(:name => "Users Who Bought Product Id #{product.id}") do |sheet|
            sheet.add_row ["product", "user_id", "email", "sign_in_count", "last_sign_in_at", "first_name", "last_name", "phone", "username", "doc_id", "created_at", "points"]
            @users.each do |user|
              sheet.add_row [
                product.permalink,
                user.id,
                user.email,
                user.sign_in_count,
                user.last_sign_in_at - 5.hours,
                user.first_name,
                user.last_name,
                user.phone,
                user.username,
                user.doc_id,
                user.created_at - 5.hours,
                user.points
              ]
            end
          end
          send_data p.to_stream.read, :filename => 'users.xlsx', :type => "application/vnd.openxmlformates-officedocument.spreadsheetml.sheet"
        }

      end
    end

    def biz_user_frequency
      @user = User.find(params[:report][:user])
      @product = Ecommerce::Product.find(params[:report][:product])

      @orders = Ecommerce::Order.includes(:user).where("ecommerce_orders.payment_status = ?", 1).where("ecommerce_orders.id IN (?)", Ecommerce::OrderItem.where(product_id: @product.id).pluck(:order_id)).where(user_id: @user.id).order(id: :desc)

      respond_to do |format|

        format.html {
          p = Axlsx::Package.new
          wb = p.workbook
          wb.add_worksheet(:name => "Order Frequency") do |sheet|
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

    def biz_product_frequency

      ActiveRecord::Base.connection.execute("DROP TABLE IF EXISTS temp_subquery")
      @product = Ecommerce::Product.find(params[:report][:product])

      @orders = Ecommerce::Order.includes(:user).where("ecommerce_orders.payment_status = ?", 1).where("ecommerce_orders.id IN (?)", Ecommerce::OrderItem.where(product_id: @product.id).pluck(:order_id)).order(:user_id)

      user_ids_with_single_order = @orders.group(:user_id).having('COUNT(ecommerce_orders.id) = 1').pluck(:user_id)

      subset_of_orders = @orders.where.not(user_id: user_ids_with_single_order)

      temp_table_sql = subset_of_orders.select(:user_id, :created_at, 'LAG(ecommerce_orders.created_at) OVER (PARTITION BY user_id ORDER BY ecommerce_orders.created_at) AS lag_created_at' ).joins(:user).to_sql
      
      ActiveRecord::Base.connection.execute("CREATE TEMPORARY TABLE temp_subquery AS #{temp_table_sql}")
      
      average_time_query = ActiveRecord::Base.connection.execute("SELECT user_id, AVG(EXTRACT(EPOCH FROM (created_at - lag_created_at))) / 86400 AS avg_time_in_days FROM temp_subquery GROUP BY user_id")

      result = ActiveRecord::Base.connection.execute("SELECT SUM(avg_time * order_count) / SUM(order_count) AS weighted_average FROM (SELECT user_id, AVG(EXTRACT(EPOCH FROM (created_at - lag_created_at))) / 86400 AS avg_time, COUNT(*) AS order_count FROM temp_subquery GROUP BY user_id) AS subquery")
      weighted_average = result[0]["weighted_average"].to_f
      ActiveRecord::Base.connection.execute("DROP TABLE IF EXISTS temp_subquery")

      
      respond_to do |format|

        format.html {
          p = Axlsx::Package.new
          wb = p.workbook
          wb.add_worksheet(:name => "Exported Orders") do |sheet|
            sheet.add_row ["Product Frequency", "#{weighted_average.round(2)} days"]
            sheet.add_row []
            sheet.add_row ["Order id","date_time", "user","amount","stage","efact", "shipping address", "phone", "coupon", "payment_status", "payment_method", "special_instructions", "status"]
            subset_of_orders.each do |order|
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

    def biz_cross_selling
      @product_1 = Ecommerce::Product.find(params[:report][:product_1])
      @product_2 = Ecommerce::Product.find(params[:report][:product_2])

      @orders = Ecommerce::Order.includes(:user).where("ecommerce_orders.payment_status = ?", 1).where("ecommerce_orders.id IN (?)", Ecommerce::OrderItem.where(product_id: @product_1.id).pluck(:order_id)).where("ecommerce_orders.id IN (?)", Ecommerce::OrderItem.where(product_id: @product_2.id).pluck(:order_id))

      @user_orders = User.joins(:orders)
                   .where(ecommerce_orders: { id: @orders })
                   .select('users.*, COUNT(ecommerce_orders.id) as total_orders')
                   .group('users.id')

      #@users = User.where(id: @orders.pluck(:user_id).uniq)

      respond_to do |format|

        format.html {
          p = Axlsx::Package.new
          wb = p.workbook
          wb.add_worksheet(:name => "Bought Ids #{@product_1.id} and #{@product_2.id}") do |sheet|
            sheet.add_row ["product 1", "product 2", "total_orders", "user_id", "email", "sign_in_count", "last_sign_in_at", "first_name", "last_name", "phone", "username", "doc_id", "created_at", "points"]
            @user_orders.each do |user|
              sheet.add_row [
                @product_1.permalink,
                @product_2.permalink,
                user.total_orders,
                user.id,
                user.email,
                user.sign_in_count,
                user.last_sign_in_at - 5.hours,
                user.first_name,
                user.last_name,
                user.phone,
                user.username,
                user.doc_id,
                user.created_at - 5.hours,
                user.points
              ]
            end
          end
          send_data p.to_stream.read, :filename => 'users.xlsx', :type => "application/vnd.openxmlformates-officedocument.spreadsheetml.sheet"
        }

      end

    end

    def biz_cross_selling_open
      @product_1_open = Ecommerce::Product.find(params[:report][:product_1_open])
      product_id = @product_1_open.id

      user_ids = Ecommerce::OrderItem.joins(:order).where(product_id: product_id).pluck('distinct ecommerce_orders.user_id')

      order_ids = Ecommerce::Order.where(user_id: user_ids).pluck(:id)

      other_order_item_ids = Ecommerce::OrderItem.where(order_id: order_ids).where.not(product_id: product_id).pluck(:id)

      popular_products = Ecommerce::OrderItem.where(id: other_order_item_ids).group(:product_id).order('count_product_id DESC').count(:product_id)

      respond_to do |format|

        format.html {
          p = Axlsx::Package.new
          wb = p.workbook
          wb.add_worksheet(:name => "Bought Ids #{@product_1_open.id}") do |sheet|
            sheet.add_row ["id", "product 1", "total_ordered"]
            popular_products.each do |product|
              sheet.add_row [
                product[0],
                Product.find(product[0]).try(:permalink),
                product[1]
              ]
            end
          end
          send_data p.to_stream.read, :filename => 'users.xlsx', :type => "application/vnd.openxmlformates-officedocument.spreadsheetml.sheet"
        }

      end

    end

    def export_products
      @products = Ecommerce::Product.all.order(id: :desc)

      respond_to do |format|

        format.html {
          p = Axlsx::Package.new
          wb = p.workbook
          wb.add_worksheet(:name => "Exported Products") do |sheet|
            sheet.add_row ["id","category_id","brand_id","supplier_id","image", "permalink","price_cents","discounted_price_cents","meta_keywords","meta_description","stockable","home_featured","category_featured","available_at","deleted_at","created_at","updated_at","description2","product_order","stockable","total_quantity","weight","status","usd_price_cents","usd_discounted_price_cents","coupon_id","name","short_description","description","category_list","tax_list (igv: 1, isc: 2)"]
            @products.each do |product|
              sheet.add_row [
                product.id, product.category_id, product.brand_id, product.supplier_id, product.image, product.permalink, product.price_cents, product.discounted_price_cents, product.meta_keywords, product.meta_description, product.stockable, product.home_featured, product.category_featured, product.available_at, product.deleted_at, product.created_at, product.updated_at, product.description2, product.product_order, product.stockable, product.total_quantity, product.weight.to_s, product.status, product.usd_price_cents, product.usd_discounted_price_cents, product.coupon_id, product.name, product.short_description, product.description, product.category_list, product.product_taxes.pluck(:tax_id, :tax_amount).try(:to_s)
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

    def export_points


      @total_earned_points = (PointsTransaction.active.where(tx_type: ['purchase', 'referral', 'customer_service']).sum(:points)).try(:abs)
      @total_redeeemed_points = (PointsTransaction.active.where(tx_type: 'redemption').sum(:points)).try(:abs)
      @total_expired_points = (PointsTransaction.active.where(tx_type: ['expiration', 'void', 'refund']).sum(:points)).try(:abs)
      @total_owed_points = @total_earned_points - @total_redeeemed_points - @total_expired_points

      initial_year = 2021
      initial_month = 1

      current_year = Time.now.year
      current_month = Time.now.month

      points_report_grid = Hash.new

      respond_to do |format|

        format.html {
          p = Axlsx::Package.new
          wb = p.workbook
          wb.add_worksheet(:name => "Exported Points") do |sheet|
            sheet.add_row ["Global Totals", "Total Earned", "Total Redeemed", "Total Expired", "Total Owed"]
            sheet.add_row ['', @total_earned_points, @total_redeeemed_points, @total_expired_points, @total_owed_points]
            sheet.add_row
            sheet.add_row ["Month / Year / Concept","Points x month"]


            for r_year in initial_year..current_year
              for r_month in initial_month..current_month
                begin_date = "1/#{r_month}/#{r_year}".to_date
                puts 'begin_date:'
                puts begin_date
                end_date = begin_date.end_of_month
                puts 'end_date:'
                puts end_date

                earned_key_name = "#{r_year} #{Date::MONTHNAMES[r_month]} Earned:"
                redeemed_key_name = "#{r_year} #{Date::MONTHNAMES[r_month]} Redeemed:"
                expired_key_name = "#{r_year} #{Date::MONTHNAMES[r_month]} Expired:"

                points_report_grid[earned_key_name] = (PointsTransaction.active.where(tx_type: ['purchase', 'referral', 'customer_service']).where(created_at: begin_date..end_date).sum(:points)).try(:abs)
                points_report_grid[redeemed_key_name] = (PointsTransaction.active.where(tx_type: 'redemption').where(created_at: begin_date..end_date).sum(:points)).try(:abs)
                points_report_grid[expired_key_name] = (PointsTransaction.active.where(tx_type: ['expiration', 'void', 'refund']).where(created_at: begin_date..end_date).sum(:points)).try(:abs)

                sheet.add_row [earned_key_name, points_report_grid[earned_key_name]]
                sheet.add_row [redeemed_key_name, points_report_grid[redeemed_key_name]]
                sheet.add_row [expired_key_name, points_report_grid[expired_key_name]]
              end
            end
            sheet.add_row
            sheet.add_row ["Earned includes purchase, referral and customer_service"]
            sheet.add_row ["Expired includes refunds, void and expired"]

          end

          send_data p.to_stream.read, :filename => 'Points Report.xlsx', :type => "application/vnd.openxmlformates-officedocument.spreadsheetml.sheet"
        }

      end
    end

    private

    def redirect_drivers_to_recent_orders
      if current_user&.driver?
        redirect_to backoffice_recent_orders_path
      end
    end

  end
end
