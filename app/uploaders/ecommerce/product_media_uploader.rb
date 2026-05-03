# Handles both images and videos for the product gallery (mounted on
# Ecommerce::ProductMedia#file). Image processing (versions/resizes) only runs
# when the upload is actually an image, so video uploads pass through untouched.
class Ecommerce::ProductMediaUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :fog

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def fog_attributes
    { 'Cache-Control' => "public, max-age=#{365.days.to_i}" }
  end

  def cache_dir
    "#{Rails.root}/public/uploads/tmp"
  end

  IMAGE_EXTS = %w[jpg jpeg gif png webp].freeze
  VIDEO_EXTS = %w[mp4 mov].freeze

  version :medium_400, if: :image? do
    process resize_to_limit: [400, 400]
  end

  version :thumb_100, from_version: :medium_400, if: :image? do
    process resize_to_limit: [100, 100]
  end

  def extension_allowlist
    IMAGE_EXTS + VIDEO_EXTS
  end

  # Called by version conditionals at multiple points in the upload lifecycle.
  # The `file` argument can be an ActionDispatch::Http::UploadedFile (raw upload),
  # a CarrierWave::SanitizedFile (cached), or a CarrierWave::Storage::Fog::File
  # (stored) — none share the same API. Trust the model's media_type column,
  # which is set from a hidden form field, and fall back to file inspection
  # only when the model isn't populated yet.
  def image?(new_file = nil)
    mt = model&.media_type.to_s
    return true if mt == 'image'
    return false if mt == 'video'

    return false unless new_file
    ct = new_file.respond_to?(:content_type) ? new_file.content_type.to_s : ''
    return true if ct.start_with?('image/')

    filename =
      if new_file.respond_to?(:original_filename) then new_file.original_filename
      elsif new_file.respond_to?(:filename)       then new_file.filename
      elsif new_file.respond_to?(:path)           then new_file.path
      end
    return false unless filename
    IMAGE_EXTS.include?(File.extname(filename.to_s).delete('.').downcase)
  end

  def filename
    "#{timestamp}_#{super}" if original_filename.present?
  end

  private

  def timestamp
    var = :"@#{mounted_as}_timestamp"
    model.instance_variable_get(var) || model.instance_variable_set(var, Time.now.to_i)
  end
end
