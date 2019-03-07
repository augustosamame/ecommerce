require_dependency "ecommerce/application_controller"

module Ecommerce
  class Backoffice::CampaignsController < Backoffice::BaseController
    before_action :set_campaign, only: [:show, :edit, :update, :destroy, :send_recipients, :post_send_recipients]
    authorize_resource :class => "Ecommerce::Campaign"

    # GET /campaigns
    def index
      @campaigns = Campaign.all.order(id: :desc)
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
      user_array.each do |user_id|
        SendCampaignEmailWorker.perform_async(user_id, coupon_id, @campaign.id)
      end
      redirect_to :backoffice_campaigns, notice: "#{user_array.length} Bulk Emails sent"
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

    # GET /campaigns/1
    def show
    end

    # GET /campaigns/new
    def new
      @campaign = Campaign.new
    end

    # GET /campaigns/1/edit
    def edit
    end

    # POST /campaigns
    def create
      @campaign = Campaign.new(campaign_params)

      if @campaign.save
        redirect_to [:backoffice, @campaign], notice: 'Campaign was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /campaigns/1
    def update
      if @campaign.update(campaign_params)
        redirect_to [:backoffice, @campaign], notice: 'Campaign was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /campaigns/1
    def destroy
      @campaign.destroy
      redirect_to backoffice_campaigns_url, notice: 'Campaign was successfully destroyed.'
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_campaign
        @campaign = Campaign.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def campaign_params
        params.require(:campaign).permit(:email_subject, :email_subject_es, :email_coupon_description, :email_coupon_description_es, :image, :image_cache, :campaign_type, :coupon, :coupon_id, :name, :email_template_id, :status)
      end
  end
end
