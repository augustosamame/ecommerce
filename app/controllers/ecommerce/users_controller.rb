require_dependency "ecommerce/application_controller"

module Ecommerce
  #class StoreController < ActionController::Base
  class UsersController < ApplicationController
    prepend_view_path "ecommerce/store/#{Ecommerce.ecommerce_layout}/"
    #skip_before_action :authenticate_user!

    authorize_resource

    def show
      @user = current_user
      render "ecommerce/#{Ecommerce.ecommerce_layout}/user/show"
    end

    def points_index
      @points_transactions = PointsTransaction.where(user_id: current_user.id).order(id: :desc)
      render "ecommerce/#{Ecommerce.ecommerce_layout}/user/points_index"
    end

    def referrals_index
      @referrals = User.where(referrer_id: current_user.id).order(id: :desc)
      render "ecommerce/#{Ecommerce.ecommerce_layout}/user/referrals_index"
    end

    private

  end
end
