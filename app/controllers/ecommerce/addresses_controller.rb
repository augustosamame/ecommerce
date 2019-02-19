require_dependency "ecommerce/application_controller"

module Ecommerce
  class AddressesController < ApplicationController
    before_action :set_address, only: [:show, :edit, :update, :destroy]

    #skip_before_action :authenticate_user!, except: [:destroy]
    #skip_before_action :verify_authenticity_token, only: [:create]

    respond_to :html, :json, :js

    authorize_resource

    # GET /addresses
    # GET /addresses.json
    def index
      @addresses = Address.where(user: current_user)
      #authorize! :read, @addresses
    end

    # GET /addresses/1
    # GET /addresses/1.json
    def show
      #authorize! :read, @address
    end

    # GET /addresses/new
    def new
      @address = Address.new(user: current_user)
      @address.latitude = "-12.1051699"
      @address.longitude = "-76.9849161"
      @districts = ["Barranco", "Miraflores", "San Borja", "San Isidro", "Surco", "Callao"]
      respond_with @address
    end

    # GET /addresses/1/edit
    def edit
    end

    # POST /addresses
    # POST /addresses.json
    def create
      puts params

      @address = Address.new(address_params)
      @address.user = current_user

  #    respond_to do |format|
  #      if @address.save
          #respond_modal_with @address, location: addresses_path
          #format.html { redirect_to @address, notice: 'Address was successfully created.' }
  #        format.html { render head :ok and return }
          #format.json { render :show_ajax, status: :created, location: @address }
  #        format.json { render head :ok and return }
  #      else
  #        format.html { render :new }
  #        format.json { render json: @address.errors, status: :unprocessable_entity }
  #      end
  #    end
      respond_to do |format|
        if @address.save
          #redirect_to new_service_order_path# and return
          #respond_modal_with @address, location: pedido_path
          #head :ok
          format.html { redirect_to @address, notice: "#{t('.address_was_successfully_created')}" }
          format.js   { render action: 'show_address_ajax', status: :created, :layout => false }
        else
          format.html { render :new }
          #format.json   {render json: @address.errors, status: :unprocessable_entity }
          #format.js { render json: @address.errors, status: :unprocessable_entity }
          format.js   { render action: 'error_address_ajax', status: :unprocessable_entity }
          #format.js
        end
      end

    end

    #TODO switch to dynamic map instead of static. Search gmail for dynamic vs static for instructions
    def update_map
      @address = Address.new
      @address.street = params[:address][:street]
      @address.district = params[:address][:district]
      found_address_in_google_maps = (Geocoder.search("#{@address.street}, #{@address.district}, Lima, Peru"))[0]
      if found_address_in_google_maps
        coordinates = found_address_in_google_maps.coordinates
        @address.latitude = coordinates[0]
        @address.longitude = coordinates[1]
      else
        @error_found_address = "Google Maps could not find your address. If it's correct, don't worry, continue placing your order and we'll find the location the old-fashioned way :) "
        #@address.latitude = coordinates[0] #TODO enter not found arbitrary coordinates here
        #@address.longitude = coordinates[1] #TODO enter not found arbitrary coordinates here
      end
      respond_to do |format|
        #if @address.update(address_params)
          format.js { render action: 'update_map_ajax', status: :ok, location: @address, layout: false }
        #else
          #format.js { render json: @address.errors, status: :unprocessable_entity }
        #end
      end
    end

    # PATCH/PUT /addresses/1
    # PATCH/PUT /addresses/1.json
    def update
      respond_to do |format|
        if @address.update(address_params)
          format.html { redirect_to @address, notice: 'Address was modified.' }
          format.json { render :show, status: :ok, location: @address }
        else
          format.html { render :edit }
          format.json { render json: @address.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /addresses/1
    # DELETE /addresses/1.json
    def destroy
      @address.destroy
      respond_to do |format|
        format.html { redirect_to addresses_url, notice: 'Address was deleted.' }
        format.json { head :no_content }
      end
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_address
        @address = Address.find(params[:id])
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def address_params
        params.require(:address).permit(:name, :street, :street2, :district, :city, :state, :country, :phone, :address_type, :authorized_person, :shipping_or_billing, :raw_address, :latitude, :longitude)
      end
  end

end
