module Ecommerce
  class AdminMailer < ApplicationMailer
    default from: "ExpatShop.pe <gg@expatshop.pe>", cc: "gg@expatshop.pe", bcc: "augusto@devtechperu.com"

    def new_user_email(user, order)
      @user = user
      @order = order
      @url  = "https://#{ActionMailer::Base.default_url_options[:host]}/store/backoffice/users/#{@user.id}"
      mail(to: "gg@expatshop.pe", subject: "#{@user.name} has registered as a new User at ExpatShop.pe")
    end

    def new_order_email(user, order)
      @user = user
      @order = order
      @url  = "https://#{ActionMailer::Base.default_url_options[:host]}/store/backoffice/orders/#{@order.id}"
      mail(to: "gg@expatshop.pe", subject: "A new Order ##{@order.id} has been placed at ExpatShop.pe")
    end

    def order_paid(user, order)
      @user = user
      @order = order
      @url  = "https://#{ActionMailer::Base.default_url_options[:host]}/store/backoffice/orders/#{@order.id}"
      mail(to: "gg@expatshop.pe", subject: "Order ##{@order.id} has been paid at Expatshop.pe")
    end

    def update_to_paid_email(user, order)
      @user = user
      @order = order
      @url  = "https://#{ActionMailer::Base.default_url_options[:host]}/store/backoffice/orders/#{@order.id}"
      mail(to: "gg@expatshop.pe", subject: "Order ##{@order.id} has been been updated from UNPAID TO PAID")
    end

    def einvoice_error_email(order)
      @order = order
      @url  = "https://#{ActionMailer::Base.default_url_options[:host]}/store/backoffice/orders/#{@order.id}"
      mail(to: "augusto@devtechperu.com", subject: "There was an error generating an einvoice for Order ##{@order.id}")
    end

    def contact_us_email(name, email, phone, message)
      @name = name
      @email = email
      @phone = phone
      @message = message
      mail(to: "gg@expatshop.pe", subject: 'You have received a new message via the Contact Us Form')
    end

    def wishlist_email(name, email, phone, product_name, brand, attributes, country, comment)
      @name = name
      @email = email
      @phone = phone
      @product_name = product_name
      @brand = brand
      @country = country
      @attributes = attributes
      @comment = comment
      mail(to: "gg@expatshop.pe", subject: 'You have received a new Wish via the Wishlist Message Form')
    end

    def sales_report_email(email, file_path)
      attachments['sales_report.xlsx'] = File.read(file_path)
      mail(
        to: email,
        subject: 'ExpatShop.pe - Sales Report'
      )
    end

  end
end
