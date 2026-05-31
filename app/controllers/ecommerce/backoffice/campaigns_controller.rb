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
      @users = emailable_users
      @total_users = @users.count
      @products_array = Product.all.map{|f| {label: f.name, id: f.id}}
      #@users_array = User.standard.includes(:country).map{|f| {label: f.country_name_helper, id: f.id}}
      #@user_purchase_category_array = Order.stage_paid.includes(:user).map{|f| {label: f.user.try(:name), id: f.id}}
    end

    def post_send_recipients
      coupon_id = params[:other][:coupon_id]

      # Test-send path: admin explicitly picked one user to receive the
      # campaign. Bypass the role / guest-status filters (the whole point of
      # the test field is to send to any one specific user), but still keep
      # the compliance checks — must have an email and not be on the
      # suppression list.
      test_user_id = params[:other][:test_user_id].to_i
      if test_user_id > 0
        test_user = User.find_by(id: test_user_id)
        if test_user.nil?
          return redirect_to :backoffice_campaigns, alert: "Test user ##{test_user_id} not found."
        end
        if test_user.email.blank?
          return redirect_to :backoffice_campaigns, alert: "Test user ##{test_user_id} has no email on file."
        end
        if test_user.email_suppressed?
          return redirect_to :backoffice_campaigns, alert: "Test user ##{test_user_id} (#{test_user.email}) is on the suppression list."
        end

        SendAllCampaignEmailsWorker.perform_async([test_user.id], coupon_id, @campaign.id)
        return redirect_to :backoffice_campaigns,
                           notice: "Test email queued to user ##{test_user.id} (#{test_user.email})."
      end

      user_array = params[:other][:user_list].to_s.split(',').map(&:to_i).reject(&:zero?)

      # When the admin picks a predetermined Audience, materialize its active
      # UserAudience rows into user IDs and merge with anything the JS filters
      # already populated in user_list. Without this, an audience-only send
      # silently queues zero emails because the form's user_list stays empty.
      audience_id = params[:other][:audience_id].presence
      if audience_id
        audience_user_ids = Ecommerce::UserAudience
          .where(audience_id: audience_id, status: :active)
          .pluck(:user_id)
        user_array = (user_array + audience_user_ids).uniq
      end

      unique_users_by_email = emailable_users.where(id: user_array).uniq(&:email)

      user_ids = unique_users_by_email.map(&:id)

      if user_ids.any?
        SendAllCampaignEmailsWorker.perform_async(user_ids, coupon_id, @campaign.id)
      end

      redirect_to :backoffice_campaigns, notice: "#{user_ids.length} Bulk Emails queued (#{user_array.length - user_ids.length} skipped: suppressed/guest/duplicate)"
    end

    def get_product_purchasers
      product_id = params[:product_id].to_i
      order_items = Ecommerce::OrderItem.eager_load(:product).where('ecommerce_products.id = ?', product_id).pluck(:order_id)
      purchaser_ids = Ecommerce::Order.where(id: order_items).pluck(:user_id).uniq
      purchasers = emailable_users.where(id: purchaser_ids).pluck(:id)
      respond_to do |format|
        format.json { render json: {data: purchasers.to_json} }
      end
    end

    def get_no_purchase_within_days
      num_days = params[:days].to_i
      did_purchase = Ecommerce::Order.where('created_at >= ?', Date.today - num_days.days ).pluck(:user_id).uniq
      did_not_purchase = emailable_users.where.not(id: did_purchase).pluck(:id).uniq
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
      Rails.logger.info "=== Campaign Creation Debug Start ==="
      Rails.logger.info "Raw params: #{params[:campaign].inspect}"
      
      begin
        Rails.logger.info "Getting campaign_params..."
        filtered_params = campaign_params
        Rails.logger.info "Campaign params: #{filtered_params.inspect}"
        
        Rails.logger.info "Creating new Campaign object..."
        @campaign = Campaign.new(filtered_params)
        Rails.logger.info "Campaign object created successfully"
        Rails.logger.info "Campaign attributes: #{@campaign.attributes.inspect}"
        
        Rails.logger.info "Checking campaign validity before save..."
        is_valid = @campaign.valid?
        Rails.logger.info "Campaign valid?: #{is_valid}"
        
        if !is_valid
          Rails.logger.error "Campaign validation errors before save: #{@campaign.errors.full_messages.join(', ')}"
          Rails.logger.error "Detailed errors: #{@campaign.errors.inspect}"
        end
        
        Rails.logger.info "Attempting to save campaign..."
        if @campaign.save
          Rails.logger.info "Campaign saved successfully with ID: #{@campaign.id}"
          redirect_to [:backoffice, @campaign], notice: 'Campaign was successfully created.'
        else
          Rails.logger.error "Campaign save failed!"
          Rails.logger.error "Campaign validation failed: #{@campaign.errors.full_messages.join(', ')}"
          Rails.logger.error "Campaign errors: #{@campaign.errors.inspect}"
          Rails.logger.error "Campaign attributes after failed save: #{@campaign.attributes.inspect}"
          render :new
        end
      rescue => e
        Rails.logger.error "Exception during campaign creation: #{e.class}: #{e.message}"
        Rails.logger.error "Backtrace: #{e.backtrace.first(10).join("\n")}"
        raise e
      ensure
        Rails.logger.info "=== Campaign Creation Debug End ==="
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
        params.require(:campaign).permit(
          :email_subject, :email_subject_es,
          :email_coupon_description, :email_coupon_description_es,
          :campaign_type, :coupon, :coupon_id, :name,
          :email_template_id, :status,
          :drip_base_coupon_id, :drip_days_after, :drip_product_id,
          campaign_images_attributes: [:id, :image, :image_cache, :link, :position, :_destroy]
        )
      end

      # Excludes admin/driver/etc roles, guest accounts, users on the suppression
      # list, users with no email, and any email whose sibling row is suppressed.
      # Then collapses duplicates so each unique (LOWER+TRIM) email only appears
      # once, keeping the earliest-created row.
      def emailable_users
        @emailable_users ||= begin
          suppressed_emails_sql = User
            .where(email_suppressed: true)
            .where.not(email: [nil, ""])
            .select("LOWER(TRIM(email))")
            .to_sql

          base = User.standard.regular
                     .where.not(email_suppressed: true)
                     .where.not(email: [nil, ""])
                     .where("LOWER(TRIM(email)) NOT IN (#{suppressed_emails_sql})")

          ids = base.select("DISTINCT ON (LOWER(TRIM(email))) id")
                    .order(Arel.sql("LOWER(TRIM(email)), created_at ASC"))
                    .map(&:id)

          User.where(id: ids)
        end
      end
  end
end
