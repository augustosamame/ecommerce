require_dependency "ecommerce/application_controller"

module Ecommerce
  #class StoreController < ActionController::Base
  class CartItemsController < ApplicationController
    prepend_view_path "ecommerce/store/#{Ecommerce.ecommerce_layout}/"
    skip_before_action :authenticate_user!
    before_action :set_menu_items
    before_action :set_cart_item, only: [:destroy, :update]

    authorize_resource

    respond_to :html, :js

    def create
      @combo_discount_applied = false
      @cart_item = CartItem.new(cart_item_params)
      @product = Product.find(@cart_item.product_id)
      if @product.in_stock?
        @cart_item.cart_id = @cart.id
        found_same_product = @cart.cart_items.find_by(product_id: @cart_item.product_id)
        if found_same_product
          new_quantity = found_same_product.quantity += @cart_item.quantity
          new_quantity = @product.total_quantity if new_quantity > @product.total_quantity
          found_same_product.update(quantity: new_quantity)
          @combo_discount_exists = ComboDiscount.where(status: "active", product_id_1: @product.id, inject_product_two: true).try(:first)
          if @combo_discount_exists.present?
            @number_of_combos = (@cart_item.quantity / @combo_discount_exists.qty_product_1).floor
            @cart_item_two = CartItem.new(cart_id: @cart.id, product_id: @combo_discount_exists.product_id_2, quantity: @combo_discount_exists.qty_product_2 * @number_of_combos)
            @cart_item_two.save
            @combo_discount_applied = true
          end
        else
          #check if added item is a combo discount with force add and if so, add the second product to the cart
          @combo_discount_exists = ComboDiscount.where(status: "active", product_id_1: @product.id, inject_product_two: true).try(:first)
          if @combo_discount_exists.present?
            @number_of_combos = (@cart_item.quantity / @combo_discount_exists.qty_product_1).floor
            @cart_item_two = CartItem.new(cart_id: @cart.id, product_id: @combo_discount_exists.product_id_2, quantity: @combo_discount_exists.qty_product_2 * @number_of_combos)
            @cart_item_two.save
            @combo_discount_applied = true
          end
          @cart_item.save
          #will only save to facebook the first unique cart item
          FacebookConversionsWorker.perform_async('AddToCart', {
            email: current_user.try(:email) || "guest@expatshop.pe",
            user_id: current_user.try(:id) || "guest",
            content_type: 'product',
            content_ids: [@product.id],
            event_source_url: "https://expatshop.pe/store/cart"
          }) if Rails.env == "production"
        end
        #refresh with latest cart so it will be repainted properly
        set_cart
        respond_to do |format|
          
          format.js {
            flash.now[:notice] = "NOW_FLASH_#{t('.qty')}: #{@cart_item.quantity} #{@product.name} #{t('.added_to_cart')}";
            render "ecommerce/#{Ecommerce.ecommerce_layout}/cart_items/show"  
          }

          format.html {redirect_to cart_path(@cart) }
        end
      else
        respond_to do |format|
          format.js { flash.now[:notice] = "NOW_FLASH_#{t('.product_out_of_stock')}"; render "ecommerce/#{Ecommerce.ecommerce_layout}/cart_items/no_stock"  }

          format.html {redirect_to cart_path(@cart), notice: t('.product_out_of_stock') }
        end
      end
    end

    def update
      @cart_item.update(quantity: cart_item_params[:quantity]) unless cart_item_params[:quantity].nil?
      redirect_to @cart_item.cart, notice: t('.cart_updated')
    end

    def destroy
      @cart_item.destroy
      set_cart
      respond_to do |format|
        format.js { render "ecommerce/#{Ecommerce.ecommerce_layout}/cart_items/show" }
        format.html {redirect_to cart_path(@cart), notice: t('.item_deleted') }
      end
    end

    def index
      head :ok
    end

    def show
      head :ok
    end

    private

      def set_cart_item
        @cart_item = CartItem.find(params[:id])
      end

      def set_menu_items
        @top_bar_new_hash = Ecommerce::Control.find_by(name: 'top_bar_cookie_read_hash').text_value #this will be set as a cookie via javascript if user closes top_bar
        @primary_menu_categories = Ecommerce::Category.where(main_menu: true, category_type: "primary", status: "active").order(:category_order)
        @secondary_menu_categories = Ecommerce::Category.where(main_menu: true, category_type: "secondary", status: "active").order(:category_order)
        @homepage_categories = Ecommerce::Category.where(popular_homepage: true, status: "active").order(:category_order)
      end

      def cart_item_params
        params.require(:cart_item).permit(:cart_id, :product_id, :quantity, :status, :pre_checkout)
      end

  end
end
