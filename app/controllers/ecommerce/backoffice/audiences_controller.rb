require_dependency "ecommerce/application_controller"

module Ecommerce
  class Backoffice::AudiencesController < Backoffice::BaseController
    before_action :set_audience, only: [:show, :edit, :update, :destroy, :send_recipients, :post_send_recipients, :create_recipients, :post_create_recipients]
    authorize_resource :class => "Ecommerce::Audience"

    # GET /audiences
    def index
      @audiences = Audience.all.order(id: :desc)
    end

    def send_recipients
      @users = User.standard
      @total_users = User.standard.count
      @products_array = Product.all.map{|f| {label: f.name, id: f.id}}
      #@users_array = User.standard.includes(:country).map{|f| {label: f.country_name_helper, id: f.id}}
      #@user_purchase_category_array = Order.stage_paid.includes(:user).map{|f| {label: f.user.try(:name), id: f.id}}
    end

    def post_send_recipients
      user_array = params[:other][:user_list].split(',').map(&:to_i)
      coupon_id = params[:other][:coupon_id]
      unique_users_by_email = User.where(id: user_array).uniq{|p| p.email}
      unique_users_by_email.each do |user|
        SendAudienceEmailWorker.perform_async(user.id, coupon_id, @audience.id)
      end
      redirect_to :backoffice_audiences, notice: "#{user_array.length} Bulk Emails sent"
    end

    # GET /audiences/:id/create_recipients
    # Form for populating an audience with users. Mirrors the campaigns
    # send_recipients filters (by product purchasers / no-purchase-in-N-days)
    # so the admin can build the same kind of list, then save it as the
    # audience's membership instead of sending immediately.
    def create_recipients
      @current_member_count = Ecommerce::UserAudience.where(audience_id: @audience.id).count
      @active_member_count  = Ecommerce::UserAudience.where(audience_id: @audience.id, status: :active).count
      @products_array       = Product.all.map { |f| { label: f.name, id: f.id } }
    end

    # POST /audiences/:id/create_recipients
    # Upserts UserAudience rows for the IDs in params[:other][:user_list].
    # Mode is "add" (idempotent — duplicates are skipped) or "replace"
    # (delete the existing membership first). Always refreshes user_total
    # on the audience so the index page reflects reality.
    def post_create_recipients
      user_ids = params[:other][:user_list].to_s.split(',').map(&:to_i).reject(&:zero?).uniq
      mode     = params[:other][:mode].to_s == 'replace' ? 'replace' : 'add'

      if user_ids.empty?
        return redirect_to backoffice_audience_create_recipients_path(@audience),
                           alert: "No users selected — nothing was added."
      end

      # Drop user_ids that don't actually exist so we don't violate the
      # belongs_to :user foreign key check at insert.
      valid_user_ids = User.where(id: user_ids).pluck(:id)

      added_count   = 0
      removed_count = 0

      ActiveRecord::Base.transaction do
        if mode == 'replace'
          removed_count = Ecommerce::UserAudience.where(audience_id: @audience.id).delete_all
        end

        existing_ids = Ecommerce::UserAudience.where(audience_id: @audience.id, user_id: valid_user_ids).pluck(:user_id)
        new_ids      = valid_user_ids - existing_ids

        if new_ids.any?
          now  = Time.current
          rows = new_ids.map do |uid|
            { user_id: uid, audience_id: @audience.id, status: 1, created_at: now, updated_at: now }
          end
          Ecommerce::UserAudience.insert_all(rows)
          added_count = new_ids.length
        end

        @audience.update_column(:user_total, Ecommerce::UserAudience.where(audience_id: @audience.id).count)
      end

      notice = "Audience updated — added #{added_count} user#{'s' unless added_count == 1}"
      notice << ", removed #{removed_count}" if mode == 'replace' && removed_count > 0
      notice << ". Total members: #{@audience.user_total}."
      redirect_to backoffice_audience_create_recipients_path(@audience), notice: notice
    end

    def get_product_purchasers
      product_id = params[:product_id].to_i
      order_items = Ecommerce::OrderItem.eager_load(:product).where('ecommerce_products.id = ?', product_id).pluck(:order_id)
      purchasers = Ecommerce::Order.eager_load(:user).where(id: order_items).pluck(:user_id).uniq
      respond_to do |format|
        format.json { render json: {data: purchasers.to_json} }
      end
    end

    def get_no_purchase_within_days
      num_days = params[:days].to_i
      did_purchase = Ecommerce::Order.where('created_at >= ?', Date.today - num_days.days ).pluck(:user_id).uniq
      did_not_purchase = User.where.not(id: did_purchase).pluck(:id).uniq
      respond_to do |format|
        format.json { render json: {data: did_not_purchase.to_json} }
      end
    end

    # GET /audiences/1
    def show
    end

    # GET /audiences/new
    def new
      @audience = Audience.new
    end

    # GET /audiences/1/edit
    def edit
    end

    # POST /audiences
    def create
      @audience = Audience.new(audience_params)

      if @audience.save
        redirect_to [:backoffice, @audience], notice: 'Audience was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /audiences/1
    def update
      if @audience.update(audience_params)
        redirect_to [:backoffice, @audience], notice: 'Audience was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /audiences/1
    def destroy
      @audience.destroy
      redirect_to backoffice_audiences_url, notice: 'Audience was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_audience
        @audience = Audience.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def audience_params
        params.require(:audience).permit(:audience_name, :audience_description, :audience_type, :user_total, :status)
      end
  end
end
