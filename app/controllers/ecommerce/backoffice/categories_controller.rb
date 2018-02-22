require_dependency "ecommerce/application_controller"

module Ecommerce
  class Backoffice::CategoriesController < Backoffice::BaseController
    before_action :set_backoffice_category, only: [:show, :edit, :update, :destroy]
    authorize_resource :class => "Ecommerce::Category"

    # GET /backoffice/categories
    def index
      @backoffice_categories = Category.all.order(:category_order)
    end

    # GET /backoffice/categories/1
    def show
    end

    # GET /backoffice/categories/new
    def new
      @backoffice_category = Category.new
    end

    # GET /backoffice/categories/1/edit
    def edit
    end

    # POST /backoffice/categories
    def create
      @backoffice_category = Category.new(backoffice_category_params)

      if @backoffice_category.save
        redirect_to backoffice_category_path(@backoffice_category), notice: 'Category was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /backoffice/categories/1
    def update
      if @backoffice_category.update(backoffice_category_params)
        redirect_to backoffice_category_path(@backoffice_category), notice: 'Category was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /backoffice/categories/1
    def destroy
      @backoffice_category.destroy
      if @backoffice_category.destroyed?
        redirect_to backoffice_categories_url, notice: 'Category was successfully destroyed.'
      else
        flash[:error] = 'Category cannot be deleted due to presence of child records that have this category as parent.'
        redirect_to backoffice_categories_url
      end


    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_backoffice_category
        @backoffice_category = Category.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def backoffice_category_params
        params.require(:category).permit(:name, :parent_id, :image, :image_cache, :status, :main_menu, :category_type, :category_order, :popular_homepage, :image_popular_homepage, :image_popular_homepage_cache)
      end
  end
end
