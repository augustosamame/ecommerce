require_dependency "ecommerce/application_controller"

module Ecommerce
  #class StoreController < ActionController::Base
  class StoreController < ApplicationController
    protect_from_forgery with: :exception

    skip_before_action :authenticate_user!

    def main

      add_body_css_class('stretched no-transition')
      puts current_user
    end
  end
end
