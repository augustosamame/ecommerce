#require_dependency "ecommerce/application_controller"

module Ecommerce

  class ApplicationController < ::ApplicationController
    #include Ecommerce::BeforeRender

    protect_from_forgery with: :exception
    before_action :merge_abilities
    before_action :add_stretched_to_body_tag
    before_action :set_cart
    before_action :set_wishlist
    before_action :set_header_menu_items
    before_action :set_always_on_coupon
    #before_render :set_controller_meta_tags

    layout "ecommerce/#{Ecommerce.ecommerce_layout}"

    def add_stretched_to_body_tag
      add_body_css_class('stretched') if Ecommerce.ecommerce_layout == 'canvas_ecommerce'
      add_body_css_class('stretched') if Ecommerce.ecommerce_layout == 'canvas_shop'
      add_body_css_class('no-transition') if Ecommerce.ecommerce_layout == 'canvas_shop'
    end

    # Controllers can call this to add classes to the body tag
    def add_body_css_class(css_class)
      @body_css_classes ||= []
      @body_css_classes << css_class
    end

    def set_always_on_coupon
      @always_on_coupon = Ecommerce::Coupon.where(always_on_active: true).first
    end

    def set_controller_meta_tags
      global_controller_meta_tags(controller_name, action_name)
    end

    def locale
      case params[:set_locale]
      when "English"
        session[:locale] = 'en-PE'
      when "Español"
        session[:locale] = 'es-PE'
      else
        session[:locale] = Ecommerce.store_default_locale || 'es-PE'
      end
      redirect_to :root
    end

    private

    def set_cart
      if current_user
        @cart = Cart.where(user_id: current_user.id, status: "active").order(:id).last
        if @cart
          session[:cart_id] = @cart.id
        else
          @cart = Cart.find_by(id: session[:cart_id], status: "active") || Cart.create(user_id: current_user.id, status: "active", abandoned_email_sent: false)
          @cart.update(user_id: current_user.id)
          session[:cart_id] = @cart.id
        end
      else
        #TODO when registering or logging_in, transfer cart ownership from session to db user record
        #something like @cart.update(user_id: current_user.id)
        @cart = Cart.find_by(id: session[:cart_id], status: "active")
        unless @cart
          @cart = Cart.create(status: "active", abandoned_email_sent: false)
          session[:cart_id] = @cart.id
        end
      end
      @cart_subtotal = 0
      @cart.cart_items.includes(:product).each do |cart_item|
        @cart_subtotal += cart_item.line_total(current_user)
      end
      @cart_item_qty_total = @cart.cart_items.sum(&:quantity)
      #flash[:error] = 'this is a flash error'
    end

    def set_wishlist
      if current_user
        @wishlist = Wishlist.where(user_id: current_user.id, status: "active").order(:id).last
        if @wishlist
          session[:wishlist_id] = @wishlist.id
        else
          @wishlist = Wishlist.find_by(id: session[:wishlist_id], status: "active") || Wishlist.create(user_id: current_user.id, status: "active")
          @wishlist.update(user_id: current_user.id)
          session[:wishlist_id] = @wishlist.id
        end
      else
        #TODO when registering or logging_in, transfer wishlist ownership from session to db user record
        #something like @wishlist.update(user_id: current_user.id)
        @wishlist = Wishlist.find_by(id: session[:wishlist_id], status: "active")
        unless @wishlist
          @wishlist = Wishlist.create(status: "active")
          session[:wishlist_id] = @wishlist.id
        end
      end
    end

    def set_header_menu_items
      @primary_menu_categories = Ecommerce::Category.includes(:translations).where(main_menu: true, category_type: "primary", status: "active").order(:category_order)
      @exchange_rate = Ecommerce::Control.get_control_value("exchange_rate") || 3.3
    end

    def merge_abilities
      current_ability.merge(Ecommerce::Ability.new(current_user))
    end

    def global_controller_meta_tags(mycontroller, myaction)

      case "#{mycontroller}:#{myaction}"
      when "products:index"
        set_meta_tags title: "Products",
                      description: "Lista de Productos #{Ecommerce.site_name}",
                      og: {
                        title:    :full_title,
                        image:    'https://s3.amazonaws.com/devtechperu-expatshop-dev/static/images/expatshop_logo_circular_280x280.png'
                      }
      when "store:main"
        set_meta_tags title: "Home",
                      description: Ecommerce.meta_tags_store_main_description,
                      og: {
                        title:    :full_title,
                        image:    'https://s3.amazonaws.com/devtechperu-expatshop-dev/static/images/expatshop_logo_circular_280x280.png'
                      }
      else
        set_meta_tags description: "No match for meta_tags"
      end
    end

  end

end
