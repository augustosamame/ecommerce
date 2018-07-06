require_dependency "ecommerce/application_controller"

module Ecommerce
  class CategoriesController < ApplicationController
    prepend_view_path "ecommerce/store/#{Ecommerce.ecommerce_layout}"
    skip_before_action :authenticate_user!
    before_action :set_facebook_locale, only: [:show]

    authorize_resource

    def index

      set_index_meta_tags

      if params[:parent_category]
        @category = Category.find(params[:parent_category])
        @child_categories = Category.tagged_with(@category.name)
        if @child_categories.count > 0
          render "ecommerce/#{Ecommerce.ecommerce_layout}/category/index"
        else
          @products = Product.tagged_with(@category.name).in_stock
          render "ecommerce/#{Ecommerce.ecommerce_layout}/product/index"
        end
        #@child_categories = Category.where(parent_id: @category.id)
      end

      #render "ecommerce/#{Ecommerce.ecommerce_layout}/category/index"

    end

    def show

      #set_controller_meta_tags(action_name)

      @cart_item = CartItem.new
      @wishlist_item = CartItem.new

      set_show_meta_tags

      render "ecommerce/#{Ecommerce.ecommerce_layout}/category/show"
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_category
        @category = Category.find(params[:id])
      end

      def set_facebook_locale
        case I18n.locale[0..1]
        when 'en'
          @fb_compatible_locale_code = 'en_US'
        when 'es'
          @fb_compatible_locale_code = 'es_LA'
        else
          @fb_compatible_locale_code = 'es_LA'
        end
      end

      # Never trust parameters from the scary internet, only allow the white list through.
      def category_params
        params.require(:address).permit(:name, :tag_list)
      end

      def set_show_meta_tags
        set_meta_tags title: @category.name,
                      description: @category.description,
                      og: {
                        title: "#{@category.name} | #{Ecommerce.site_name}", #TODO change this to global value to save a db call
                        description:    @category.description,
                        image:    @category.image.medium_400.url
                      }
      end

      def set_index_meta_tags
        set_meta_tags title: "Categories",
                      description: "ExpatShop Category List",
                      og: {
                        title:    :full_title,
                        image:    Ecommerce.logo
                      }
      end

  end
end
