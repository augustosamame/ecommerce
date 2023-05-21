require_dependency "ecommerce/application_controller"

module Ecommerce
  class Backoffice::AudiencesController < Backoffice::BaseController
    before_action :set_audience, only: [:show, :edit, :update, :destroy, :send_recipients, :post_send_recipients]
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
