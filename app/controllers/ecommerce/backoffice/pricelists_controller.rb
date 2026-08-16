require_dependency "ecommerce/application_controller"

module Ecommerce
  class Backoffice::PricelistsController < Backoffice::BaseController
    before_action :set_pricelist, only: [:show, :edit, :update, :destroy, :add_product, :remove_product]
    authorize_resource :class => "Ecommerce::Pricelist"

    # GET /pricelists
    def index
      @pricelists = Pricelist.all
    end

    # GET /pricelists/1
    # Shows ONLY the products already on this pricelist (blank for a new one),
    # with controls to add/edit/remove lines — instead of rendering the whole
    # catalog with an inline price cell per product, which was unusable at
    # catalog size and made "what's actually on this list?" unanswerable.
    def show
      @product_prices = ProductPrice.where(pricelist_id: @pricelist.id)
                                    .includes(product: :translations)
                                    .order(:id)
      @addable_products = Product.active.includes(:translations)
                                 .where.not(id: @product_prices.map(&:product_id))
                                 .order(:permalink)
    end

    # POST /backoffice/pricelists/:id/add_product
    def add_product
      product = Product.find_by(id: params[:product_id])
      redirect_to [:backoffice, @pricelist], alert: "Choose a product." and return unless product

      price_cents = params[:price_cents].to_i
      redirect_to [:backoffice, @pricelist], alert: "Price (cents) must be greater than 0." and return if price_cents <= 0
      discounted = params[:discounted_price_cents].to_i
      discounted = price_cents if discounted <= 0 # no discount = discounted == price (Product#discounted? convention)

      pp = ProductPrice.find_or_initialize_by(pricelist_id: @pricelist.id, product_id: product.id)
      pp.price_cents = price_cents
      pp.discounted_price_cents = discounted
      if pp.save
        redirect_to [:backoffice, @pricelist], notice: "#{product.name} added to pricelist."
      else
        redirect_to [:backoffice, @pricelist], alert: pp.errors.full_messages.to_sentence
      end
    end

    # DELETE /backoffice/pricelists/:id/remove_product
    def remove_product
      pp = ProductPrice.find_by(id: params[:product_price_id], pricelist_id: @pricelist.id)
      pp&.destroy
      redirect_to [:backoffice, @pricelist], notice: "Product removed from pricelist (reverts to default price)."
    end

    # GET /pricelists/new
    def new
      @pricelist = Pricelist.new
      @pricelist.status = "active"
    end

    # GET /pricelists/1/edit
    def edit
    end

    # POST /pricelists
    def create
      @pricelist = Pricelist.new(pricelist_params)

      if @pricelist.save
        redirect_to [:backoffice, @pricelist], notice: 'Pricelist was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /pricelists/1
    def update
      if @pricelist.update(pricelist_params)
        redirect_to [:backoffice, @pricelist], notice: 'Pricelist was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /pricelists/1
    def destroy
      @pricelist.destroy
      redirect_to backoffice_pricelists_url, notice: 'Pricelist was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_pricelist
        @pricelist = Pricelist.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def pricelist_params
        params.require(:pricelist).permit(:name, :status)
      end
  end
end
