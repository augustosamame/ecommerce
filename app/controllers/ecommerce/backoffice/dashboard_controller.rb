module Ecommerce
  class Backoffice::DashboardController < Backoffice::BaseController

    authorize_resource :class => false

    def main
      @last_users = User.where(role: "standard").order(id: :desc).first(10)
      #@last_orders = Order.includes(:user, :address).order(id: :desc).first(10)

    end

  end
end
