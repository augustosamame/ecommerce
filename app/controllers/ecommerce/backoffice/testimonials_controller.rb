require_dependency "ecommerce/application_controller"

module Ecommerce
  class Backoffice::TestimonialsController < Backoffice::BaseController
    before_action :set_backoffice_testimonial, only: [:show, :edit, :update, :destroy]
    authorize_resource :class => "Ecommerce::Testimonial" #we have to do this because controller and model do not have the same namespace

    # GET /backoffice/testimonials
    def index
      @backoffice_testimonials = Testimonial.all.order(id: :desc)
    end

    # GET /backoffice/testimonials/1
    def show
      @testimonial_prices = ProductPrice.where(testimonial_id: @backoffice_testimonial.id)
    end

    # GET /backoffice/testimonials/new
    def new
      @backoffice_testimonial = Testimonial.new
    end

    # GET /backoffice/testimonials/1/edit
    def edit

    end

    # POST /backoffice/testimonials
    def create
      @backoffice_testimonial = Testimonial.new(backoffice_testimonial_params)
      if @backoffice_testimonial.save
        redirect_to backoffice_testimonial_path(@backoffice_testimonial), notice: 'Testimonial was successfully created.'
      else
        Rails.logger.error @backoffice_testimonial.errors
        render :new
      end
    end

    # PATCH/PUT /backoffice/testimonials/1
    def update
      if @backoffice_testimonial.update(backoffice_testimonial_params)
        @backoffice_testimonial.save
        redirect_to backoffice_testimonial_path(@backoffice_testimonial), notice: 'Testimonial was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /backoffice/testimonials/1
    def destroy
      @backoffice_testimonial.destroy
      redirect_to backoffice_testimonials_url, notice: 'Testimonial was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_backoffice_testimonial
        @backoffice_testimonial = Testimonial.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def backoffice_testimonial_params
        params.require(:testimonial).permit(:user_fullname, :user_title, :product_name, :video, :video_cache, :thumbnail, :thumbnail_cache, :priority, :status)
      end
  end
end
