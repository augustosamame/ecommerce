#require_dependency "ecommerce/application_controller"

module Ecommerce

  class ApplicationController < ::ApplicationController
    #include Ecommerce::BeforeRender
    skip_before_action :authenticate_user!, only: [:mov_to_mp4_success, :mov_to_mp4_error]

    protect_from_forgery with: :exception, except: [:mov_to_mp4_success, :mov_to_mp4_error]
    before_action :merge_abilities
    before_action :add_stretched_to_body_tag
    before_action :set_cart
    before_action :calculate_combo_discounts
    # before_action :set_wishlist
    before_action :set_header_menu_items
    before_action :set_always_on_coupon
    #before_render :set_controller_meta_tags

    layout "ecommerce/#{Ecommerce.ecommerce_layout}"

    def calculate_combo_discounts
      @exchange_rate = Ecommerce::Control.get_control_value("exchange_rate") || 3.8
      
      @combo_discount_array = []
      @friendly_combo_discount_array = []

      my_cart = Cart.where(id: session[:cart_id], status: "active").order(:id).last
      if my_cart
        cart_items = my_cart.cart_items
        cart_items_product_ids = cart_items.pluck(:product_id).flatten.uniq
        combo_discounts_product_ids = Ecommerce::ComboDiscount.pluck(:product_id_1, :product_id_2).flatten.compact.uniq
        common_product_ids = (cart_items_product_ids & combo_discounts_product_ids)

        if common_product_ids.present?

          #consolidate_cart_items
          consolidated_cart_items = {}
          cart_items.each do |item|
            if consolidated_cart_items.key?(item[:product_id])
              # If it exists, add the cart_product_qty to the existing value
              consolidated_cart_items[item[:product_id]][:quantity] += item[:quantity]
            else
              # If it doesn't exist, create a new entry in the consolidated_cart_items hash
              consolidated_cart_items[item[:product_id]] = item
            end
          end
          consolidated_cart_items = consolidated_cart_items.values

          # Print the consolidated cart items
          consolidated_cart_items.each do |item|
            puts "Product ID: #{item[:product_id]}, Quantity: #{item[:quantity]}"
          end

          global_discount = 0
          global_discount_usd = 0
          Ecommerce::ComboDiscount.active.each do |combo_discount|

            cart_item_that_matches_combo_discount_product_1 = nil
            cart_item_that_matches_combo_discount_product_2 = nil
            combo_added = false
            number_of_combos = 0

            #find_matching_product_1
            consolidated_cart_items.each do |item|
              matching_product_1 = combo_discount.product_id_1 == item[:product_id]
              if matching_product_1 && combo_discount.qty_product_1 <= item[:quantity]
                number_of_combos = (item[:quantity] / combo_discount.qty_product_1).floor
                cart_item_that_matches_combo_discount_product_1 = item
              end
            end
            
            if cart_item_that_matches_combo_discount_product_1
              if combo_discount.product_id_2.present?
                #find_matching_product_2
                consolidated_cart_items.each do |item|
                  matching_product_2 = combo_discount.product_id_2 == item[:product_id]

                  #check if product 1 and product 2 are the same
                  if combo_discount.product_id_1 == combo_discount.product_id_2
                    actual_qty_in_cart = cart_item_that_matches_combo_discount_product_1[:quantity]
                    min_qty = combo_discount.qty_product_1 + combo_discount.qty_product_2
                    if actual_qty_in_cart >= min_qty
                      if matching_product_2 && combo_discount.qty_product_2 <= item[:quantity]
                        new_number_of_combos = (item[:quantity] / (combo_discount.qty_product_2 + combo_discount.qty_product_1)).floor
                        #check that the number of combos for product 2 is less or equal than the number of combos for product 1
                        
                        number_of_combos = new_number_of_combos
                        
                        cart_item_that_matches_combo_discount_product_2 = item
                        @combo_discount_array << combo_discount
                        combo_added = true
                      end
                    end
                  else
                    if matching_product_2 && combo_discount.qty_product_2 <= item[:quantity]
                      new_number_of_combos = (item[:quantity] / combo_discount.qty_product_2).floor
                      #check that the number of combos for product 2 is less or equal than the number of combos for product 1
                      if new_number_of_combos <= number_of_combos
                        number_of_combos = new_number_of_combos
                      end
                      cart_item_that_matches_combo_discount_product_2 = item
                      @combo_discount_array << combo_discount
                      combo_added = true
                    end
                  end
                end
              else
                @combo_discount_array << combo_discount
                combo_added = true
              end
            end

            if combo_added

              line_discount = 0
              line_discount_usd = 0
              discount_prod_1 = 0
              discount_prod_2 = 0
              if combo_discount.discount_type == "percentage_discount"
                product_price = cart_session_price(cart_item_that_matches_combo_discount_product_1.product)
                discount_prod_1 = combo_discount.qty_product_1 * product_price * (combo_discount.discount_amount.to_f / 100) * number_of_combos.to_f
                if cart_item_that_matches_combo_discount_product_2.present?
                  product_price = cart_session_price(cart_item_that_matches_combo_discount_product_2.product)
                  discount_prod_2 = combo_discount.qty_product_2 * product_price * combo_discount.discount_amount.to_f / 100 * number_of_combos.to_f
                end
                line_discount = discount_prod_1 + discount_prod_2
                line_discount_usd = session[:currency] == "usd" ? line_discount : (line_discount / @exchange_rate)
                global_discount_usd += line_discount_usd
              elsif combo_discount.discount_type == "fixed_discount"
                line_discount = session[:currency] == "usd" ? (combo_discount.discount_amount * number_of_combos) : (combo_discount.discount_amount * number_of_combos * @exchange_rate)
                line_discount_usd = combo_discount.discount_amount * number_of_combos
                global_discount_usd += line_discount_usd
              end
              @friendly_combo_discount_array << {product_name: session[:locale] == "en-PE" ? combo_discount.description_en : combo_discount.description_es, discount_amount: line_discount}
              @combo_total_discount_usd = global_discount_usd
            end

          end

        end
      end
    end

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

    def cart_session_price(product)
      case session[:currency]
      when "pen"
        value = product.current_price(current_user).to_s.to_f
        return value * @exchange_rate
      when "usd"
        value = product.current_price(current_user).to_s.to_f
        return value
      else
        raise "Invalid currency"
      end
    end


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
      @exchange_rate = Ecommerce::Control.get_control_value("exchange_rate") || 3.8
      @primary_menu_categories = Ecommerce::Category.includes(:translations).where(main_menu: true, category_type: "primary", status: "active").order(:category_order)
    end

    def merge_abilities
      current_ability.merge(Ecommerce::Ability.new(current_user))
    end

    def global_controller_meta_tags(mycontroller, myaction)

      case "#{mycontroller}:#{myaction}"
      when "products:index"
        set_meta_tags title: "Expatshop.pe Products",
                      description: "Lista de Productos #{Ecommerce.site_name}",
                      og: {
                        title:    :full_title,
                        image:    'https://s3.amazonaws.com/devtechperu-expatshop-dev/static/images/expatshop_logo_circular_280x280.png'
                      }
      when "store:main"
        set_meta_tags title: "Expatshop.pe Home",
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
