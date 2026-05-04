module Ecommerce
  class PushCampaign < ApplicationRecord
    self.table_name = "ecommerce_push_campaigns"

    belongs_to :coupon, optional: true
    belongs_to :audience, optional: true
    belongs_to :target_product, class_name: "Ecommerce::Product", optional: true

    enum campaign_type: {next_purchase_push: 0, bulk_push: 1, product_drip_push: 2}
    enum status: {inactive: 0, active: 1}

    validates :title, presence: true
    validates :body, presence: true

    def localized_title
      I18n.locale.to_s.start_with?('es') ? title_es.presence || title : title
    end

    def localized_body
      I18n.locale.to_s.start_with?('es') ? body_es.presence || body : body
    end
  end
end
