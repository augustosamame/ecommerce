module Ecommerce
  class ShoppingVideo < ApplicationRecord
    has_many :shopping_video_overlays, dependent: :destroy
    accepts_nested_attributes_for :shopping_video_overlays, reject_if: :all_blank, allow_destroy: true

    enum status: { active: 0, inactive: 1}
    enum processing_status: {pending: 0, processing: 1, completed: 2, failed: 3}

    attr_accessor :video_processing

    mount_uploader :video, Ecommerce::ShoppingVideoUploader
    mount_uploader :thumbnail, Ecommerce::ShoppingVideoImageUploader

    validates :title, presence: true
    validates :video, presence: true
    validates :thumbnail, presence: true

    validates :priority, uniqueness: true

    after_commit :check_video_changed

    def queue_video_processing

      Rails.logger.info("Queueing video processing for URL #{self.id}")

      MediaConvertWorker.perform_in(60.seconds, self.id)

      #s3_key = self.video.path.sub(/^#{Regexp.escape('expatshop-prod-mov-in')}\//, '')
      #MediaConvertWorker.perform_async(ENV['S3_MOV_IN_BUCKET_NAME'], s3_key)

      #VideoProcessingWorker.perform_in(5.seconds, self.id)
    end

    def update_processed_video(new_video_url)
      Rails.logger.info("Updating processed video for URL #{self.id}, new_video_url: #{new_video_url}")
      self.remote_video_url = new_video_url.gsub('s3://expatshop-prod/', 'https://expatshop-prod.s3.amazonaws.com/')
      self.processing_status = :completed
      self.save(validate: false)
    end

    private

    def check_video_changed
      if saved_change_to_video?
        self.update_column(:processing_status, :processing)
        queue_video_processing
      end
    end

  end
end
