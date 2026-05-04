require_dependency "ecommerce/application_controller"

module Ecommerce
  class Backoffice::PushCampaignsController < Backoffice::BaseController
    before_action :set_push_campaign, only: [:show, :edit, :update, :destroy, :send_recipients, :post_send_recipients]
    authorize_resource :class => "Ecommerce::PushCampaign"

    # GET /push_campaigns
    def index
      @push_campaigns = PushCampaign.all.order(id: :desc)
    end

    def send_recipients
      @users = User.standard
      @total_app_users = User.where.not(expo_push_token: [nil, ""]).count
      @products_array = Product.all.map{|f| {label: f.name, id: f.id}}
    end

    def get_all_app_users
      scope = User.where.not(expo_push_token: [nil, ""])
      render json: build_recipients_payload(scope)
    end

    def post_send_recipients
      user_array = params[:other][:user_list].to_s.split(',').map(&:to_i).reject(&:zero?)
      coupon_id = params[:other][:coupon_id]
      target_users = User.where(id: user_array).where.not(expo_push_token: [nil, ""])
      user_ids = target_users.pluck(:id).uniq

      if user_ids.any?
        SendAllPushCampaignNotificationsWorker.perform_async(user_ids, coupon_id, @push_campaign.id)
      end

      redirect_to :backoffice_push_campaigns, notice: "#{user_ids.length} push notifications queued (filtered to users with push tokens)."
    end

    def get_product_purchasers
      product_id = params[:product_id].to_i
      order_items = Ecommerce::OrderItem.eager_load(:product).where('ecommerce_products.id = ?', product_id).pluck(:order_id)
      purchaser_ids = Ecommerce::Order.where(id: order_items).pluck(:user_id).uniq
      scope = User.where(id: purchaser_ids).where.not(expo_push_token: [nil, ""])
      render json: build_recipients_payload(scope)
    end

    def get_no_purchase_within_days
      num_days = params[:days].to_i
      did_purchase = Ecommerce::Order.where('created_at >= ?', Date.today - num_days.days).pluck(:user_id).uniq
      scope = User.where.not(id: did_purchase).where.not(expo_push_token: [nil, ""])
      render json: build_recipients_payload(scope)
    end

    # GET /push_campaigns/1
    def show
    end

    # GET /push_campaigns/new
    def new
      @push_campaign = PushCampaign.new
    end

    # GET /push_campaigns/1/edit
    def edit
    end

    # POST /push_campaigns
    def create
      @push_campaign = PushCampaign.new(push_campaign_params)
      if @push_campaign.save
        redirect_to [:backoffice, @push_campaign], notice: 'Push Campaign was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /push_campaigns/1
    def update
      if @push_campaign.update(push_campaign_params)
        redirect_to [:backoffice, @push_campaign], notice: 'Push Campaign was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /push_campaigns/1
    def destroy
      @push_campaign.destroy
      redirect_to backoffice_push_campaigns_url, notice: 'Push Campaign was successfully destroyed.'
    end

    private

    def set_push_campaign
      @push_campaign = PushCampaign.find(params[:id])
    end

    def push_campaign_params
      params.require(:push_campaign).permit(:name, :campaign_type, :status, :coupon_id, :audience_id, :title, :title_es, :body, :body_es, :target_product_id)
    end

    RECIPIENT_PREVIEW_LIMIT = 200

    # Returns ids (CSV target for the form) plus a previewable list of users.
    # Capped at RECIPIENT_PREVIEW_LIMIT rows in the preview to keep the page small.
    def build_recipients_payload(scope)
      ids = scope.pluck(:id)
      preview = scope.limit(RECIPIENT_PREVIEW_LIMIT)
                     .pluck(:id, :first_name, :last_name, :email, :username)
                     .map do |id, fn, ln, em, un|
        {
          id: id,
          name: "#{fn} #{ln}".strip,
          email: em,
          phone: un
        }
      end
      {
        data: ids.to_json,
        users: preview,
        total: ids.size,
        preview_limit: RECIPIENT_PREVIEW_LIMIT
      }
    end
  end
end
