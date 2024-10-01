require 'streamio-ffmpeg'
require 'open-uri'

class VideoProcessingWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'video_processing'

  def perform(shopping_video_id)
    shopping_video = Ecommerce::ShoppingVideo.find(shopping_video_id)
    shopping_video.update_column(:processing_status, 'processing')

    begin
      # Download file from S3
      s3_object = shopping_video.video
      local_file_path = "/tmp/#{File.basename(s3_object.path)}"
      File.open(local_file_path, 'wb') do |file|
        file.write(s3_object.read)
      end

      # Process video
      video = FFMPEG::Movie.new(local_file_path)
      output_path = "/tmp/#{File.basename(local_file_path, '.*')}_converted.mp4"

      video.transcode(output_path, encoding_options)

      # Upload processed file back to S3
      File.open(output_path) do |file|
        shopping_video.update_column(:video, file)
      end

      shopping_video.update_column(:processing_status, 'completed')

      # Clean up temporary files
      File.delete(local_file_path) if File.exist?(local_file_path)
      File.delete(output_path) if File.exist?(output_path)

    rescue => e
      shopping_video.update_column(:processing_status, 'failed')
      Rails.logger.error "Video processing failed for ShoppingVideo #{shopping_video_id}: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")
    end
  end

  private

  def encoding_options
    {
      video_codec: 'libx264',
      audio_codec: 'aac',
      custom: %w(
        -pix_fmt yuv420p
        -profile:v main
        -level 3.1
        -movflags +faststart
        -crf 23
        -preset medium
        -maxrate 5M
        -bufsize 10M
        -ar 44100
        -b:a 128k
      )
    }
  end
end