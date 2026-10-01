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
        # Oldest row is the customer's own; a later row of the same product is
        # a combo-injected bonus (see Cart#combo_bonus_items).
        found_same_product = @cart.cart_items.where(product_id: @cart_item.product_id).order(:id).first
        if found_same_product
          new_quantity = found_same_product.quantity += @cart_item.quantity
          new_quantity = @product.total_quantity if new_quantity > @product.total_quantity
          found_same_product.update(quantity: new_quantity)
        else
          # Saved before the bonus is injected so the customer's row is the oldest.
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
        #if the added item triggers a combo discount with force add, add (or resize) the second product in the cart
        @combo_discount_applied = @cart.sync_combo_bonus(@product.id)
        #refresh with latest cart so it will be repainted properly
        set_cart
        calculate_combo_discounts
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
      # Free Product coupon line is locked at qty 1 — silently no-op so the UI
      # disable + this backend guard stay aligned against direct POSTs.
      # Same for a combo-injected bonus row: its quantity follows the trigger.
      if @cart_item.free_product_line? || combo_bonus_row?(@cart_item)
        redirect_to @cart_item.cart and return
      end
      unless cart_item_params[:quantity].nil?
        @cart_item.update(quantity: cart_item_params[:quantity])
        @cart_item.cart.sync_combo_bonus(@cart_item.product_id)
      end
      redirect_to @cart_item.cart, notice: t('.cart_updated')
    end

    def destroy
      # Free Product coupon line cannot be removed while the coupon is active.
      # Neither can a combo-injected bonus row while its trigger is in the cart.
      if @cart_item.free_product_line? || combo_bonus_row?(@cart_item)
        respond_to do |format|
          format.js { render "ecommerce/#{Ecommerce.ecommerce_layout}/cart_items/show" }
          format.html { redirect_to cart_path(@cart) }
        end
        return
      end

      # If removing a trigger product, also remove its combo-injected free product
      @cart_item.cart.remove_combo_bonus(@cart_item.product_id)
      @cart_item.destroy
      set_cart
      calculate_combo_discounts
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

      # Set by the calculate_combo_discounts before_action.
      def combo_bonus_row?(cart_item)
        @combo_injected_cart_item_ids.to_a.include?(cart_item.id)
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
