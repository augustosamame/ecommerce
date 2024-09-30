require_dependency "ecommerce/application_controller"

module Ecommerce
  class ShoppingVideosController < ApplicationController
    include ActionView::Helpers::NumberHelper
    
    def overlays
      shopping_video = Ecommerce::ShoppingVideo.find(params[:id])
      overlays = shopping_video.shopping_video_overlays.map do |overlay|
        {
          product_id: overlay.product.id,
          product_name: overlay.product.name,
          product_price: number_to_currency(overlay.product.price),
          product_image_url: overlay.product.image_url,
          start_time: overlay.start_time,
          end_time: overlay.end_time
        }
      end
      render json: overlays
    end
  end
end