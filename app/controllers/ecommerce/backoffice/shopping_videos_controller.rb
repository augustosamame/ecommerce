require_dependency "ecommerce/application_controller"

module Ecommerce
  class Backoffice::ShoppingVideosController < Backoffice::BaseController
    before_action :set_shopping_video, only: [:show, :edit, :update, :destroy]

    authorize_resource :class => "Ecommerce::ShoppingVideo"

    def index
      @shopping_videos = Ecommerce::ShoppingVideo.all
    end

    def show
    end

    def new
      Rails.logger.info "shopping_videos NEW action."
      @shopping_video = Ecommerce::ShoppingVideo.new
      @shopping_video.shopping_video_overlays.build
    end

    def create
      Rails.logger.info "shopping_videos CREATE action. Params: #{shopping_video_params}"
      @shopping_video = Ecommerce::ShoppingVideo.new(shopping_video_params)

      @shopping_video.video_processing = true if @shopping_video.video.present?

      if @shopping_video.save
        flash[:notice] = "Video uploaded successfully. It will be processed shortly."
        redirect_to backoffice_shopping_video_path(@shopping_video)
      else
        render :new
      end
    end

    def edit
    end

    def update
      @shopping_video.assign_attributes(shopping_video_params)
      @shopping_video.video_processing = true if @shopping_video.video.present?

      if @shopping_video.save
        flash[:notice] = if @shopping_video.video_processing
                           'Shopping video was successfully updated and will be reprocessed shortly.'
                         else
                           'Shopping video was successfully updated.'
                         end
        redirect_to backoffice_shopping_video_path(@shopping_video)
      else
        render :edit
      end
    end

    def destroy
      @shopping_video.destroy
      redirect_to backoffice_shopping_videos_path, notice: 'Shopping video was successfully destroyed.'
    end

    private

    def set_shopping_video
      @shopping_video = Ecommerce::ShoppingVideo.find(params[:id])
    end

    def shopping_video_params
      video_params = params.require(:shopping_video).permit(:title, :description, :priority, :video, :video_cache, :thumbnail, :thumbnail_cache, :status, :processing_status,
        shopping_video_overlays_attributes: [:id, :product_id, :category_id, :overlay_type, :start_time, :end_time, :status, :_destroy])
      
      if video_params[:video].present? && video_params[:video].respond_to?(:original_filename)
        original_filename = video_params[:video].original_filename
        new_filename = original_filename.gsub(' ', '_').downcase
        video_params[:video].original_filename = new_filename
      end

      video_params
    end
  
  end
end
