require 'streamio-ffmpeg'
require 'open-uri'
require 'securerandom'

class VideoProcessingWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'video_processing', retry: 3

  def perform(shopping_video_id)
    in_path  = "/tmp/sv_#{shopping_video_id}_in_#{SecureRandom.hex(4)}.mp4"
    out_path = "/tmp/sv_#{shopping_video_id}_out_#{SecureRandom.hex(4)}.mp4"

    shopping_video = Ecommerce::ShoppingVideo.find(shopping_video_id)
    shopping_video.update_column(:processing_status, Ecommerce::ShoppingVideo.processing_statuses[:processing])

    src_url = shopping_video.video.url
    Rails.logger.info "[VideoProcessing #{shopping_video_id}] downloading #{src_url}"
    URI.open(src_url, read_timeout: 120) do |remote|
      File.open(in_path, 'wb') { |f| IO.copy_stream(remote, f) }
    end

    movie = FFMPEG::Movie.new(in_path)
    raise "Invalid video file at #{in_path}" unless movie.valid?
    Rails.logger.info "[VideoProcessing #{shopping_video_id}] source codec=#{movie.video_codec} #{movie.resolution} #{movie.duration.to_i}s — transcoding"

    movie.transcode(out_path, encoding_options)

    Rails.logger.info "[VideoProcessing #{shopping_video_id}] uploading converted file via CarrierWave"
    File.open(out_path, 'rb') do |f|
      shopping_video.skip_video_processing = true
      shopping_video.video = f
      shopping_video.processing_status = :completed
      shopping_video.save!(validate: false)
    end

    Rails.logger.info "[VideoProcessing #{shopping_video_id}] done — new url: #{shopping_video.reload.video.url}"
  rescue => e
    Ecommerce::ShoppingVideo.where(id: shopping_video_id)
      .update_all(processing_status: Ecommerce::ShoppingVideo.processing_statuses[:failed])
    Rails.logger.error "[VideoProcessing #{shopping_video_id}] FAILED: #{e.class} #{e.message}"
    Rails.logger.error e.backtrace.first(20).join("\n")
    raise
  ensure
    File.delete(in_path)  if in_path  && File.exist?(in_path)
    File.delete(out_path) if out_path && File.exist?(out_path)
  end

  private

  def encoding_options
    {
      video_codec: 'libx264',
      audio_codec: 'aac',
      custom: %w(
        -pix_fmt yuv420p
        -profile:v main
        -level 4.0
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
