module Ecommerce
  class CampaignImage < ApplicationRecord
    belongs_to :campaign, inverse_of: :campaign_images

    mount_uploader :image, Ecommerce::CampaignImageUploader

    validates :image, presence: true
    validates :link, format: URI::regexp(%w[http https]), allow_blank: true

    before_validation :assign_position, on: :create

    private

    def assign_position
      return if position.present? && position != 0
      max = campaign&.campaign_images&.maximum(:position) || -1
      self.position = max + 1
    end
  end
end
