require_dependency "ecommerce/application_controller"

module Ecommerce
  class Backoffice::PricelistsController < Backoffice::BaseController
    before_action :set_pricelist, only: [:show, :edit, :update, :destroy, :add_product, :update_product, :remove_product]
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

      # Soles is the price B2B invoicing uses and the only required one; the
      # USD price is optional, entered in DOLLARS (decimal), and only feeds
      # the web store.
      pen_price = params[:pen_price].to_d
      redirect_to [:backoffice, @pricelist], alert: "Precio S/ must be greater than 0." and return if pen_price <= 0
      price_cents = (params[:usd_price].to_d * 100).round
      discounted = (params[:usd_discounted_price].to_d * 100).round
      discounted = price_cents if discounted <= 0 # no discount = discounted == price (Product#discounted? convention)

      pp = ProductPrice.find_or_initialize_by(pricelist_id: @pricelist.id, product_id: product.id)
      pp.pen_price = pen_price
      pp.price_cents = price_cents
      pp.discounted_price_cents = discounted
      if pp.save
        redirect_to [:backoffice, @pricelist], notice: "#{product.name} added to pricelist."
      else
        redirect_to [:backoffice, @pricelist], alert: pp.errors.full_messages.to_sentence
      end
    end

    # PATCH /backoffice/pricelists/:id/update_product
    # Saves one row of the pricelist table (soles price + optional USD dollars).
    def update_product
      pp = ProductPrice.find_by(id: params[:product_price_id], pricelist_id: @pricelist.id)
      redirect_to [:backoffice, @pricelist], alert: "Price row not found." and return unless pp

      pen_price = params[:pen_price].to_d
      redirect_to [:backoffice, @pricelist], alert: "Precio S/ must be greater than 0." and return if pen_price <= 0

      pp.pen_price = pen_price
      # Re-derived from pen_price by the model unless explicitly set.
      pp.pen_discounted_price = nil
      # USD amounts arrive in DOLLARS (decimal) and are stored as cents.
      pp.price_cents = (params[:usd_price].to_d * 100).round if params[:usd_price].present?
      pp.discounted_price_cents = (params[:usd_discounted_price].to_d * 100).round if params[:usd_discounted_price].present?

      if pp.save
        redirect_to [:backoffice, @pricelist], notice: "#{pp.product.name} price updated."
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
