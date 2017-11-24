require_dependency "ecommerce/application_controller"

module Ecommerce
  #class StoreController < ActionController::Base
  class StoreController < ApplicationController
    protect_from_forgery with: :exception

    skip_before_action :authenticate_user!

    def main
      puts current_user
    end
  end
end
