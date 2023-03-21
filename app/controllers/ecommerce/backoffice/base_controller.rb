module Ecommerce
  class Backoffice::BaseController < ApplicationController
    layout 'ecommerce/backoffice'

    check_authorization

    before_action :authorize_role
    before_action :set_dashboard_searches
    before_action :set_default_locale

    def authorize_role
      #raise CanCan::AccessDenied unless current_or_guest_user.admin? || current_or_guest_user.auxiliary? || current_or_guest_user.transportista?
      raise CanCan::AccessDenied unless current_user.admin? || current_user.auxiliary?
    end

    def set_dashboard_searches
      @redis = Redis.new(host: ENV['REDIS_ENDPOINT'])
      if @redis.get("all_users")
        @users_array = JSON.parse(@redis.get("all_users"))
      else
        set_user_dashboard_searches
      end
      if @redis.get("all_orders")
        @orders_array = JSON.parse(@redis.get("all_orders"))
      else
        set_order_dashboard_searches
      end
      if @redis.get("all_products")
        @products_array = JSON.parse(@redis.get("all_products"))
        @category_products_array = JSON.parse(@redis.get("all_category_products"))
      else
        set_product_dashboard_searches
      end
    end

    def set_user_dashboard_searches
      @users_array = User.all.order(id: :desc).map{|f| {label: f.name, id: f.id}}
      @redis.setex("all_users", 600, @users_array.to_json)
    end

    def set_order_dashboard_searches
      @orders_array = Order.all.includes(:user).order(id: :desc).map{|f| {label: "Order ##{f.id} - #{f.user.name}", value: f.user.name, id: f.id}}
      @redis.setex("all_orders", 600, @orders_array.to_json)
    end

    def set_product_dashboard_searches
      @products_array = Product.all.map{|f| {label: "#{f.name}", value: f.name, id: f.id}}
      @category_products_array = Product.all.map{|f| {label: "#{f.name} - #{f.category_list.to_csv}", value: f.name, id: f.id}}
      @redis.setex("all_products", 600, @products_array.to_json)
      @redis.setex("all_category_products", 600, @category_products_array.to_json)
    end

    def set_default_locale
      I18n.locale = session[:locale] || Ecommerce.backoffice_default_locale
    end

  end
end
