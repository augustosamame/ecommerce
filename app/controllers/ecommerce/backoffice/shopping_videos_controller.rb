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
      @shopping_video = Ecommerce::ShoppingVideo.new
      @shopping_video.shopping_video_overlays.build
    end

    def create
      @shopping_video = Ecommerce::ShoppingVideo.new(shopping_video_params)
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
      if @shopping_video.update(shopping_video_params)
        flash[:notice] = if @shopping_video.video_changed?
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
      params.require(:shopping_video).permit(:title, :description, :priority, :video, :video_cache, :thumbnail, :thumbnail_cache, :status, :processing_status,
        shopping_video_overlays_attributes: [:id, :product_id, :start_time, :end_time, :status,:_destroy])
    end
  
  end
end
