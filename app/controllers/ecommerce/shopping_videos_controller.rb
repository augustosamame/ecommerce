require_dependency "ecommerce/application_controller"

module Ecommerce
  class ShoppingVideosController < ApplicationController
    include ActionView::Helpers::NumberHelper
    include Ecommerce::ApplicationHelper

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