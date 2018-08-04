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
      @users_array = User.all.map{|f| {label: f.name, id: f.id}}
      #@products_array = Product.all.map{|f| {label: "#{f.name} - #{f.price_cents.to_soles}", value: f.name, id: f.id}}
      @products_array = Product.all.map{|f| {label: "#{f.name}", value: f.name, id: f.id}}
      @category_products_array = Product.all.map{|f| {label: "#{f.name} - #{f.category_list.to_csv}", value: f.name, id: f.id}}
      @orders_array = Order.all.includes(:user).map{|f| {label: "Order ##{f.id} - #{f.user.name}", value: f.user.name, id: f.id}}
    end

    def set_default_locale
      I18n.locale = Ecommerce.backoffice_default_locale
    end

  end
end
