module Ecommerce
  class Backoffice::BaseController < ApplicationController
    layout 'ecommerce/backoffice'

    check_authorization

    before_action :authorize_role
    before_action :set_products_and_users_search

    def authorize_role
      #raise CanCan::AccessDenied unless current_or_guest_user.admin? || current_or_guest_user.auxiliary? || current_or_guest_user.transportista?
      raise CanCan::AccessDenied unless current_user.admin? || current_user.auxiliary?
    end

    def set_products_and_users_search
      @users_array = User.all.map{|f| {label: f.name, id: f.id}}
      #@products_array = Product.all.map{|f| {label: "#{f.name} - #{f.price_cents.to_soles}", value: f.name, id: f.id}}
    end

  end
end
