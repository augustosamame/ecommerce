require_dependency "ecommerce/application_controller"

module Ecommerce
  class Backoffice::AddressesController < ApplicationController
    before_action :set_backoffice_address, only: [:show, :edit, :update, :destroy]

    # GET /backoffice/addresses
    def index
      @backoffice_addresses = Address.all
    end

    # GET /backoffice/addresses/1
    def show
    end

    # GET /backoffice/addresses/new
    def new
      @backoffice_address = Address.new
    end

    # GET /backoffice/addresses/1/edit
    def edit
    end

    # POST /backoffice/addresses
    def create
      @backoffice_address = Address.new(backoffice_address_params)

      if @backoffice_address.save
        redirect_to backoffice_address_path(@backoffice_address), notice: 'Address was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /backoffice/addresses/1
    def update
      if @backoffice_address.update(backoffice_address_params)
        redirect_to backoffice_address_path(@backoffice_address), notice: 'Address was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /backoffice/addresses/1
    def destroy
      @backoffice_address.destroy
      redirect_to backoffice_addresses_url, notice: 'Address was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_backoffice_address
        @backoffice_address = Address.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def backoffice_address_params
        params.require(:address).permit(:user_id, :name, :street, :street2, :state, :city, :address_type, :shipping_or_billing, :status)
      end
  end
end
