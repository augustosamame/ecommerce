require_dependency "ecommerce/application_controller"

module Ecommerce
  class TestimonialsController < ApplicationController
    prepend_view_path "ecommerce/store/#{Ecommerce.ecommerce_layout}"
    skip_before_action :authenticate_user!
    
    authorize_resource

    def index

      set_index_meta_tags

      @all_products = Product.all.includes(:translations).order(:product_order).active
      @products = Product.all.includes(:translations).order(:product_order).active.page(params[:page])

      @all_testimonials = Testimonial.all.order(:priority).active
      @testimonials = Testimonial.all.order(:priority).active.page(params[:page])
      render "ecommerce/#{Ecommerce.ecommerce_layout}/testimonial/index"
    end

    def show
      #set_controller_meta_tags(action_name)

      render "ecommerce/#{Ecommerce.ecommerce_layout}/testimonial/show"
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_testimonial
        @testimonial = Testimonial.find(params[:id])
      end

      def set_index_meta_tags
        set_meta_tags title: "Testimonials",
                      description: "ExpatShop Testimonial List",
                      og: {
                        title:    :full_title,
                        image:    Ecommerce.logo
                      }
      end

  end
end
