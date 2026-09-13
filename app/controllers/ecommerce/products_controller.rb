require_dependency "ecommerce/application_controller"

module Ecommerce
  class ProductsController < ApplicationController
    prepend_view_path "ecommerce/store/#{Ecommerce.ecommerce_layout}"
    skip_before_action :authenticate_user!
    before_action :set_product, only: [:show]
    before_action :set_facebook_locale, only: [:show]

    authorize_resource

    def index

      set_index_meta_tags
      @hidden_footer = true

      if params[:search]
        if @banana_permission
          @products = Product.search_by_name(params[:search]).active.then { |scope| listing_filters(scope) }.page(params[:page])
        else
          @products = Product.search_by_name(params[:search]).active_not_banana.then { |scope| listing_filters(scope) }.page(params[:page])
        end

        #FB Conversions API
        FacebookConversionsWorker.perform_async('Search', {
          email: current_user.try(:email) || "guest@expatshop.pe",
          user_id: current_user.try(:id) || "guest",
          search_string: params[:search],
          event_source_url: "https://expatshop.pe/store/products"
      }) if Rails.env == "production"

        render "ecommerce/#{Ecommerce.ecommerce_layout}/product/index" and return
      end

      if params[:filter]
        @filter = params[:filter]
        case @filter
        when "new_products"
          #@products = Product.where('created_at > ?', 30.days.ago).includes(:translations).active.order(:product_order).then { |scope| listing_filters(scope) }.page(params[:page])
          new_products_category_id = Rails.env.production? ? 47 : 11
          @category = Category.find(new_products_category_id)
          Globalize.with_locale('en-PE') do
            @products = Product.includes(:translations).tagged_with(@category.name).active.order(:product_order).then { |scope| listing_filters(scope) }.page(params[:page])
          end
        when "discounted_products"
          @products = Product.where('ecommerce_products.price_cents != ecommerce_products.discounted_price_cents').includes(:translations).active.order(:product_order).then { |scope| listing_filters(scope) }.page(params[:page])
        end
        render "ecommerce/#{Ecommerce.ecommerce_layout}/product/index" and return
      end

      if params[:category_id]
        @category = Category.find(params[:category_id])
        #@child_categories = Category.where(parent_id: @category.id)
        Globalize.with_locale(Ecommerce.backoffice_default_locale) do
          @child_categories = Category.tagged_with(@category.name)
        end
        if @child_categories.count > 0
          redirect_to categories_path(parent_category: @category.id)
        else
          Globalize.with_locale(Ecommerce.backoffice_default_locale) do
            if @banana_permission
              @all_products = Product.includes(:translations).tagged_with(@category.name).active.order(:product_order)
              @products = Product.includes(:translations).tagged_with(@category.name).active.order(:product_order).then { |scope| listing_filters(scope) }.page(params[:page])
            else
              @all_products = Product.includes(:translations).tagged_with(@category.name).active_not_banana.order(:product_order)
              @products = Product.includes(:translations).tagged_with(@category.name).active_not_banana.order(:product_order).then { |scope| listing_filters(scope) }.page(params[:page])
            end
          end
          #FB Conversions API
          FacebookConversionsWorker.perform_async('ViewContent', {
            email: current_user.try(:email) || "guest@expatshop.pe",
            user_id: current_user.try(:id) || "guest",
            event_source_url: "https://expatshop.pe/store/products?category=#{params[:category_id]}"
          }) if Rails.env == "production"
          render "ecommerce/#{Ecommerce.ecommerce_layout}/product/index"
        end
      else
        if @banana_permission
          @all_products = Product.all.includes(:translations).active.order(:product_order)
          @products = Product.all.includes(:translations).active.order(:product_order).then { |scope| listing_filters(scope) }.page(params[:page])
        else
          @all_products = Product.all.includes(:translations).active_not_banana.order(:product_order)
          @products = Product.all.includes(:translations).active_not_banana.order(:product_order).then { |scope| listing_filters(scope) }.page(params[:page])
        end
        render "ecommerce/#{Ecommerce.ecommerce_layout}/product/index"
      end
    end

    def show
      #set_controller_meta_tags(action_name)

      @cart_item = CartItem.new
      @wishlist_item = CartItem.new

      @related_products = Ecommerce::Product.where(category_id: @product.category_id).active.order(:product_order).limit(20)

      set_show_meta_tags

      FacebookConversionsWorker.perform_async('ViewContent', {
        email: current_user.try(:email) || "guest@expatshop.pe",
        user_id: current_user.try(:id) || "guest",
        event_source_url: "https://expatshop.pe/store/products/#{@product.try(:permalink)}"
      }) if Rails.env == "production"

      render "ecommerce/#{Ecommerce.ecommerce_layout}/product/show"
    end

    def favorites
      # Anonymous traffic (logged-out users, bots, scanners) reaches this
      # action because the controller skips authenticate_user! globally. The
      # action is meaningless without a user — bounce them out instead of
      # crashing on `current_user.id`.
      unless current_user
        redirect_back fallback_location: root_path
        return
      end

      if Ecommerce::Order.where(user_id: current_user.id).exists?
        user_orders_items = Ecommerce::OrderItem.where(order_id: current_user.user_orders.pluck(:id)).group(:product_id).order(Arel.sql('COUNT(*) DESC')).select('product_id').pluck(:product_id)
        @products = Product.where(id: user_orders_items).includes(:translations).order(:product_order).active.then { |scope| listing_filters(scope) }.page(params[:page])
        render "ecommerce/#{Ecommerce.ecommerce_layout}/product/index"
      else
        redirect_back fallback_location: root_path
      end
    end

    def search
      redirect_to products_path(search: params[:search])
    end

    def stock_alert
      if current_user
        @product = Ecommerce::Product.find(params[:stock_alert][:product_id])
        stock_alert_exists = Ecommerce::StockAlert.find_by(user_id: current_user.id, product_id: @product.id)
        if stock_alert_exists
          stock_alert_exists.update(status: 0)
        else
          Ecommerce::StockAlert.create(user_id: current_user.id, product_id: @product.id, status: 0)
        end
        respond_to do |format|
          format.js { flash.now[:notice] = "NOW_FLASH_#{t('.stock_alert_set')}"; render "ecommerce/#{Ecommerce.ecommerce_layout}/product/stock_alert"  }

          format.html {redirect_to product_path(@product) }
        end
      else
        respond_to do |format|
          format.js { flash.now[:notice] = "NOW_FLASH_#{t('.stock_alert_set')}"; render "ecommerce/#{Ecommerce.ecommerce_layout}/product/stock_alert_signed_out"  }

          format.html {redirect_to product_path(@product) }
        end
      end
    end


    # ---- GlobalCanasta listing filters ----------------------------------
    # Origin / price / availability facets and the sort select on the
    # listing page. `scope` is the fully built (unpaginated) relation for the
    # current branch; the pre-filter relation is kept in @listing_base so the
    # view can render facet counts that don't collapse once a filter is on.
    LISTING_SORTS = {
      "popular"    => nil,
      "price_asc"  => Arel.sql("ecommerce_products.discounted_price_cents ASC"),
      "price_desc" => Arel.sql("ecommerce_products.discounted_price_cents DESC"),
      "newest"     => Arel.sql("ecommerce_products.created_at DESC"),
    }.freeze

    def listing_filters(scope)
      @listing_base = scope
      @listing_countries = Array(params[:country]).reject(&:blank?)
      @listing_availability = params[:availability].presence
      @listing_price = params[:price].presence
      @listing_sort = LISTING_SORTS.key?(params[:sort].to_s) ? params[:sort].to_s : "popular"

      scope = scope.where(country: @listing_countries) if @listing_countries.any?
      scope = scope.where("ecommerce_products.total_quantity > 0") if @listing_availability == "in_stock"
      if @listing_price && (m = @listing_price.match(/\A(\d*)-(\d*)\z/))
        # Product prices are stored in USD; bucket bounds arrive in the
        # session currency, so convert soles back through the exchange rate.
        rate = session[:currency] == "usd" ? 1.0 : (Ecommerce::Control.get_control_value("exchange_rate") || 3.8).to_f
        scope = scope.where("ecommerce_products.discounted_price_cents >= ?", (m[1].to_f / rate * 100).round) if m[1].present?
        scope = scope.where("ecommerce_products.discounted_price_cents < ?", (m[2].to_f / rate * 100).round) if m[2].present?
      end
      order = LISTING_SORTS[@listing_sort]
      scope = scope.reorder(order) if order
      scope
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_product
        @product = Product.friendly.find(params[:id])
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
      def product_params
        params.require(:address).permit(:name, :tag_list, :coupon, :coupon_id)
      end

      def set_show_meta_tags
        product_url = "#{request.base_url}/store/products/#{@product.permalink}"
        product_desc = @product.description&.gsub("**", " ")&.truncate(160)
        set_meta_tags title: @product.name,
                      description: product_desc,
                      canonical: product_url,
                      og: {
                        title: "#{@product.name} | #{Ecommerce.site_name}",
                        description: product_desc,
                        image: @product.image.medium_400.url,
                        url: product_url,
                        type: "product"
                      },
                      twitter: {
                        card: "summary_large_image",
                        title: "#{@product.name} | #{Ecommerce.site_name}",
                        description: product_desc,
                        image: @product.image.medium_400.url
                      },
                      alternate: {
                        "es-PE" => "#{product_url}?lang=es-PE",
                        "en" => "#{product_url}?lang=en-PE"
                      }
      end

      def set_index_meta_tags
        index_url = "#{request.base_url}/store/products"
        set_meta_tags title: "Products",
                      description: "#{Ecommerce.site_name} product list - imported products from around the world to Perú",
                      canonical: index_url,
                      og: {
                        title: :full_title,
                        image: Ecommerce.logo,
                        url: index_url,
                        type: "website"
                      },
                      twitter: {
                        card: "summary",
                        title: :full_title,
                        image: Ecommerce.logo
                      }
      end

  end
end
