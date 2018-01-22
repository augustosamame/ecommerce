require_dependency "ecommerce/application_controller"

module Ecommerce
  #class StoreController < ActionController::Base
  class StoreController < ApplicationController
    skip_before_action :authenticate_user!

    def main

      add_body_css_class('stretched')
      @top_bar_new_hash = Ecommerce::Control.find_by(name: 'top_bar_cookie_read_hash').text_value #this will be set as a cookie via javascript if user closes top_bar
      @home_menu_categories = Category.where(main_menu: true, status: "active") 
    end

  end
end
