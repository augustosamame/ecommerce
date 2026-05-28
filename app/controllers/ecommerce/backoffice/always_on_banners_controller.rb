require_dependency "ecommerce/application_controller"

module Ecommerce
  class Backoffice::AlwaysOnBannersController < Backoffice::BaseController
    before_action :set_always_on_banner, only: [:show, :edit, :update, :destroy]
    authorize_resource :class => "Ecommerce::AlwaysOnBanner"

    # GET /backoffice/always_on_banners
    def index
      @always_on_banners = AlwaysOnBanner.all.order(id: :desc)
    end

    # GET /backoffice/always_on_banners/1
    def show
    end

    # GET /backoffice/always_on_banners/new
    def new
      @always_on_banner = AlwaysOnBanner.new(status: :active, web_enabled: true, app_enabled: true)
    end

    # GET /backoffice/always_on_banners/1/edit
    def edit
    end

    # POST /backoffice/always_on_banners
    def create
      @always_on_banner = AlwaysOnBanner.new(always_on_banner_params)
      if @always_on_banner.save
        redirect_to backoffice_always_on_banner_path(@always_on_banner), notice: 'Always On Banner was successfully created.'
      else
        Rails.logger.error @always_on_banner.errors.full_messages
        render :new
      end
    end

    # PATCH/PUT /backoffice/always_on_banners/1
    def update
      if @always_on_banner.update(always_on_banner_params)
        redirect_to backoffice_always_on_banner_path(@always_on_banner), notice: 'Always On Banner was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /backoffice/always_on_banners/1
    def destroy
      @always_on_banner.destroy
      redirect_to backoffice_always_on_banners_url, notice: 'Always On Banner was successfully destroyed.'
    end

    private

    def set_always_on_banner
      @always_on_banner = AlwaysOnBanner.find(params[:id])
    end

    def always_on_banner_params
      params.require(:always_on_banner).permit(:message_en, :message_es, :link_url, :web_enabled, :app_enabled, :status)
    end
  end
end
