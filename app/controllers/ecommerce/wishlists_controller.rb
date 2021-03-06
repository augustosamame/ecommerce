require_dependency "ecommerce/application_controller"

module Ecommerce
  class WishlistsController < ApplicationController
    skip_before_action :authenticate_user!
    before_action :set_wishlist, only: [:show, :edit, :update, :destroy]

    authorize_resource

    # GET /wishlists/1
    def show
      @wishlist_qty_subtotal = @wishlist.wishlist_items.includes(:product).sum(:quantity)
      @wishlist_subtotal = 0
      @wishlist.wishlist_items.includes(:product).each do |wishlist_item|
        @wishlist_subtotal += wishlist_item.line_total(current_user)
      end
      render "ecommerce/#{Ecommerce.ecommerce_layout}/wishlist/show"
    end

    # GET /wishlists/1/edit
    def edit
    end

    # PATCH/PUT /wishlists/1
    def update
      if @wishlist.update(wishlist_params)
        redirect_to @wishlist, notice: 'Wishlist was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /wishlists/1
    def destroy
      @wishlist.destroy
      redirect_to wishlists_url, notice: 'Wishlist was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_wishlist
        @wishlist = Wishlist.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def wishlist_params
        params.require(:wishlist).permit(:user_id, :status)
      end
  end
end
