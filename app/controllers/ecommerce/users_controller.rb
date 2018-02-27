require_dependency "ecommerce/application_controller"

module Ecommerce
  #class StoreController < ActionController::Base
  class UsersController < ApplicationController
    prepend_view_path "ecommerce/store/#{Ecommerce.ecommerce_layout}/"
    #skip_before_action :authenticate_user!

    def show
      @user = current_user
      render "ecommerce/#{Ecommerce.ecommerce_layout}/user/show"
    end

    private

  end
end
