require_dependency "ecommerce/application_controller"

module Ecommerce
  class Backoffice::SlidersController < Backoffice::BaseController
    before_action :set_backoffice_slider, only: [:show, :edit, :update, :best_in_place_update, :destroy]
    authorize_resource :class => "Ecommerce::Slider"

    # GET /backoffice/sliders
    def index
      @backoffice_sliders = Slider.all.order(:slider_view, :slider_order)
    end

    # GET /backoffice/sliders/1
    def show
    end

    # GET /backoffice/sliders/new
    def new
      @backoffice_slider = Slider.new
    end

    # GET /backoffice/sliders/1/edit
    def edit
    end

    # POST /backoffice/sliders
    def create
      @backoffice_slider = Slider.new(backoffice_slider_params)

      if @backoffice_slider.save
        redirect_to backoffice_slider_path(@backoffice_slider), notice: 'Slider was successfully created.'
      else
        render :new, notice: "Slider was not successfully created: Errors: #{backoffice_slider.errors.inspect}"
      end
    end

    # PATCH/PUT /backoffice/sliders/1
    def update
      if @backoffice_slider.update(backoffice_slider_params)
        redirect_to backoffice_slider_path(@backoffice_slider), notice: 'Slider was successfully updated.'
      else
        render :edit
      end
    end

    def best_in_place_update
      if @backoffice_slider.update(backoffice_slider_params)
        head :ok
      else
        Rails.logger.error "Unable to update slider order in place. Error: #{@backoffice_slider.errors.inspect}"
        head :ok
      end
    end

    # DELETE /backoffice/sliders/1
    def destroy
      @backoffice_slider.destroy
      redirect_to backoffice_sliders_url, notice: 'Slider was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_backoffice_slider
        @backoffice_slider = Slider.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def backoffice_slider_params
        params.require(:slider).permit(:slider_name, :slider_text, :slider_image, :slider_image_cache, :slider_view, :slider_order, :status)
      end
  end
end
