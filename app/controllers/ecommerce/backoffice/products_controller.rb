require_dependency "ecommerce/application_controller"

module Ecommerce
  class Backoffice::ProductsController < Backoffice::BaseController
    before_action :set_backoffice_product, only: [:show, :edit, :update, :best_in_place_update, :best_in_place_translation_update, :destroy]
    authorize_resource :class => "Ecommerce::Product" #we have to do this because controller and model do not have the same namespace

    # GET /backoffice/products
    def index
      @backoffice_products = Product.all.order(:product_order, id: :desc)
    end

    # GET /backoffice/products/1
    def show
      @product_prices = ProductPrice.where(product_id: @backoffice_product.id)
    end

    # GET /backoffice/products/new
    def new
      @backoffice_product = Product.new
      @backoffice_product.stockable = true
      @tax1 = Ecommerce::Tax.first.try(:tax_name)
      @tax2 = Ecommerce::Tax.second.try(:tax_name)
      @tax3 = Ecommerce::Tax.third.try(:tax_name)
      default_taxes = Ecommerce::Control.find_by!(name: "default_taxes").text_value.split(",")
      counter = 1
      default_taxes.each_cons(2) { |tax, amount|
        eval("@backoffice_product.tax_#{counter}_check = true")
        eval("@backoffice_product.tax_#{counter}_amount = amount.to_f")
        counter +=1
      }

      #@backoffice_product.product_skus.build
    end

    # GET /backoffice/products/1/edit
    def edit
      #@backoffice_product.tax_1_check = @backoffice_product.product_taxes.try(:first).try(:tax).try(:name)
      @tax1 = Ecommerce::Tax.first.try(:tax_name)
      @tax2 = Ecommerce::Tax.second.try(:tax_name)
      @tax3 = Ecommerce::Tax.third.try(:tax_name)
      #counter = 1
      found_igv = @backoffice_product.product_taxes.find_by(tax_id: Ecommerce::Tax.first.try(:id))
      @backoffice_product.tax_1_check = true if found_igv
      @backoffice_product.tax_1_amount = found_igv.try(:tax_amount) if @backoffice_product.tax_1_check
      found_isc = @backoffice_product.product_taxes.find_by(tax_id: Ecommerce::Tax.second.try(:id))
      @backoffice_product.tax_2_check = true if found_isc
      @backoffice_product.tax_2_amount = found_isc.try(:tax_amount) if @backoffice_product.tax_2_check
      found_other = @backoffice_product.product_taxes.find_by(tax_id: Ecommerce::Tax.third.try(:id))
      @backoffice_product.tax_3_check = true if found_other
      @backoffice_product.tax_3_amount = found_other.try(:tax_amount) if @backoffice_product.tax_3_check

      #@backoffice_product.product_taxes.each do |pt|
      #  eval("@backoffice_product.tax_#{counter}_check = true")
      #  eval("@backoffice_product.tax_#{counter}_amount = pt.tax_amount")
      #  counter +=1
      #end
    end

    # POST /backoffice/products
    def create
      @backoffice_product = Product.new(backoffice_product_params)
      @backoffice_product.usd_price_cents = @backoffice_product.price_cents
      @backoffice_product.usd_discounted_price_cents = @backoffice_product.discounted_price_cents
      @backoffice_product.category_list.add(backoffice_product_params[:category_id])
      #@backoffice_product.permalink = @backoffice_product.name
      if @backoffice_product.save
        set_taxes_from_params
        redirect_to backoffice_product_path(@backoffice_product), notice: 'Product was successfully created.'
      else
        Rails.logger.error @backoffice_product.errors
        render :new
      end
    end

    # PATCH/PUT /backoffice/products/1
    def update
      if @backoffice_product.update(backoffice_product_params)
        set_taxes_from_params
        @backoffice_product.category_list = backoffice_product_params[:category_id]
        @backoffice_product.usd_price_cents = @backoffice_product.price_cents
        @backoffice_product.usd_discounted_price_cents = @backoffice_product.discounted_price_cents
        @backoffice_product.save
        redirect_to backoffice_product_path(@backoffice_product), notice: 'Product was successfully updated.'
      else
        render :edit
      end
    end

    def best_in_place_update
      if @backoffice_product.update(backoffice_product_params)
        head :ok
      else
        Rails.logger.error "Unable to update product order in place. Error: #{@backoffice_product.errors.inspect}"
        head :ok
      end
    end

    def best_in_place_translation_update
      if @backoffice_product.update(backoffice_product_params)
        head :ok
      else
        Rails.logger.error "Unable to update product order in place. Error: #{@backoffice_product.errors.inspect}"
        head :ok
      end
    end

    def set_taxes_from_params
      if backoffice_product_params[:tax_1_check] == "0" || backoffice_product_params[:tax_1_check].blank?
        found_tax = Ecommerce::Tax.first
        found_product_tax = Ecommerce::ProductTax.find_by(tax_id: found_tax.try(:id), product_id: @backoffice_product.id)
        found_product_tax.destroy if found_product_tax
      else
        found_tax = Ecommerce::Tax.first
        found_product_tax = Ecommerce::ProductTax.find_by(tax_id: found_tax.try(:id), product_id: @backoffice_product.id)
        if found_product_tax
          found_product_tax.update(tax_amount: backoffice_product_params[:tax_1_amount])
        else
          Ecommerce::ProductTax.create(tax_id: found_tax.id, product_id: @backoffice_product.id, tax_amount: backoffice_product_params[:tax_1_amount])
        end
      end
      if backoffice_product_params[:tax_2_check] == "0" || backoffice_product_params[:tax_2_check].blank?
        found_tax = Ecommerce::Tax.second
        found_product_tax = Ecommerce::ProductTax.find_by(tax_id: found_tax.try(:id), product_id: @backoffice_product.id)
        found_product_tax.destroy if found_product_tax
      else
        found_tax = Ecommerce::Tax.second
        found_product_tax = Ecommerce::ProductTax.find_by(tax_id: found_tax.try(:id), product_id: @backoffice_product.id)
        if found_product_tax
          found_product_tax.update(tax_amount: backoffice_product_params[:tax_2_amount])
        else
          Ecommerce::ProductTax.create(tax_id: found_tax.id , product_id: @backoffice_product.id, tax_amount: backoffice_product_params[:tax_2_amount])
        end
      end
      if backoffice_product_params[:tax_3_check] == "0" || backoffice_product_params[:tax_3_check].blank?
        found_tax = Ecommerce::Tax.third
        found_product_tax = Ecommerce::ProductTax.find_by(tax_id: found_tax.try(:id), product_id: @backoffice_product.id)
        found_product_tax.destroy if found_product_tax
      else
        found_tax = Ecommerce::Tax.third
        found_product_tax = Ecommerce::ProductTax.find_by(tax_id: found_tax.try(:id), product_id: @backoffice_product.id)
        if found_product_tax
          found_product_tax.update(tax_amount: backoffice_product_params[:tax_3_amount])
        else
          Ecommerce::ProductTax.create(tax_id: found_tax.id, product_id: @backoffice_product.id, tax_amount: backoffice_product_params[:tax_3_amount])
        end
      end
    end

    # DELETE /backoffice/products/1
    def destroy
      @backoffice_product.destroy
      redirect_to backoffice_products_url, notice: 'Product was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_backoffice_product
        @backoffice_product = Product.friendly.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def backoffice_product_params
        params.require(:product).permit(:weight, :coupon, :coupons, :coupon_id, :tax_1_check, :tax_1_amount, :tax_2_check, :tax_2_amount, :tax_3_check, :tax_3_amount, :status, :brand_id, :supplier_id, :name, :short_description, :description, :description2, :price_cents, :discounted_price_cents, :total_quantity, :stockable, :home_featured, :product_order, :image, :image_cache, Product.globalize_attribute_names, category_id: [], category_list: [], coupon_ids: [], :product_skus_attributes => [:id, :sku, :price_cents, :status, :_destroy])
      end
  end
end
