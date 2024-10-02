require_dependency "ecommerce/application_controller"

module Ecommerce
  class ShoppingVideosController < ApplicationController
    include ActionView::Helpers::NumberHelper
    include Ecommerce::ApplicationHelper

    skip_before_action :verify_authenticity_token, only: [:mov_to_mp4_success, :mov_to_mp4_error, :new_mov_in_s3]
    skip_before_action :authenticate_user!, only: [:mov_to_mp4_success, :mov_to_mp4_error, :new_mov_in_s3]

    def new_mov_in_s3
      Rails.logger.info("New mov in s3")
      Rails.logger.info "SNS Raw Message: #{request.raw_post}"
      Rails.logger.info(params)
      message = JSON.parse(request.raw_post)
    
      if message['Records']
        message['Records'].each do |record|
          if record['eventName'].start_with?('ObjectCreated:')
            bucket = record['s3']['bucket']['name']
            key = record['s3']['object']['key']
            MovToMp4TranscoderWorker.perform_async(bucket, key)
          end
        end
      end

      head :ok
    end

    def mov_to_mp4_success
      Rails.logger.info("Mov to mp4 success")
      Rails.logger.info(params)
      Rails.logger.info "SNS Raw Message: #{request.raw_post}"
      message = JSON.parse(request.raw_post)
    
      if message['state'] == 'COMPLETED'
        # Process the successful transcoding
        output_key = message['outputs'][0]['key']
        Rails.logger.info "Transcoding completed for #{output_key}"
        # Add any additional processing here
      else
        Rails.logger.error "Transcoding failed: #{message['message']}"
      end

      head :ok
    end

    def mov_to_mp4_error
      Rails.logger.info("Mov to mp4 error")
      Rails.logger.info(params)
      Rails.logger.info "SNS Raw Message: #{request.raw_post}"
      sns_message = JSON.parse(request.raw_post)

      render json: {message: "Mov to mp4 error"}
    end

    def show
      @shopping_video = Ecommerce::ShoppingVideo.find(params[:id])
      render json: {
        title: @shopping_video.title,
        description: @shopping_video.description,
        video_url: @shopping_video.video_url
      }
    end

    def overlays
      shopping_video = Ecommerce::ShoppingVideo.find(params[:id])
      overlays = shopping_video.shopping_video_overlays.active.map do |overlay|
        {
          product_id: overlay&.product&.id,
          product_name: overlay&.product&.name,
          product_price: overlay&.overlay_type == "product" ? product_session_price(overlay&.product, "price") : nil,
          product_image_url: overlay&.product&.image_url,
          category_id: overlay&.category&.id,
          category_name: overlay&.category&.name,
          category_image_url: overlay&.category&.image_url,
          overlay_type: overlay&.overlay_type,
          start_time: overlay.start_time,
          end_time: overlay.end_time,
          add_to_cart_label: I18n.t("ecommerce.shopping_videos.add_to_cart_label"),
          view_products_label: I18n.t("ecommerce.shopping_videos.view_products_label")
        }
      end
      render json: overlays
    end

  end
end