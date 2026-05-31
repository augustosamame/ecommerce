require_dependency "ecommerce/application_controller"

module Ecommerce
  class Backoffice::AbandonedCartsController < Backoffice::BaseController
    skip_authorization_check

    DEFAULT_MIN_HOURS = 4

    def index
      @min_hours = parse_min_hours(params[:min_hours])
      cutoff = @min_hours.hours.ago

      # Active carts older than the cutoff that have at least one cart_item.
      # Eager-load user + items + products so the table renders without N+1s.
      scope = Ecommerce::Cart
        .where(status: :active)
        .where("ecommerce_carts.created_at < ?", cutoff)
        .where(id: Ecommerce::CartItem.select(:cart_id))
        .includes(:user, cart_items: :product)
        .order(created_at: :desc)

      @total_carts        = scope.count
      @carts_with_user    = scope.where.not(user_id: nil).count
      @carts_without_user = @total_carts - @carts_with_user
      @total_items        = Ecommerce::CartItem.where(cart_id: scope.select(:id)).sum(:quantity)
      @total_value_cents  = Ecommerce::CartItem
        .joins(:product)
        .where(cart_id: scope.select(:id))
        .sum("ecommerce_cart_items.quantity * COALESCE(ecommerce_products.discounted_price_cents, ecommerce_products.price_cents, 0)")

      @carts = scope.page(params[:page]).per(50)

      # Pull the most recent abandoned_cart EmailSend row per cart on this
      # page so the view can show sent / opened / clicked timestamps without
      # N+1 lookups. The mailer records subject_type='Ecommerce::Cart',
      # subject_id=cart.id, subtype='abandoned_cart'.
      cart_ids = @carts.map(&:id)
      sends_by_cart = Ecommerce::EmailSend
        .where(subject_type: 'Ecommerce::Cart', subject_id: cart_ids, subtype: 'abandoned_cart')
        .order(sent_at: :asc)
        .index_by(&:subject_id)
      @email_send_by_cart_id = sends_by_cart
    end

    private

    def parse_min_hours(value)
      hours = value.to_i
      hours > 0 ? hours : DEFAULT_MIN_HOURS
    end
  end
end
