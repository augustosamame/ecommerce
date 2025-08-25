class Ecommerce::ProofOfDeliveryImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  if Rails.env.production?
    storage :fog
  else
    storage :file
  end

  # Override the directory where uploaded files will be stored.
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Process files as they are uploaded:
  # Resize only if width is greater than 800px, maintaining aspect ratio
  process :resize_to_width_limit => 800

  # Create different versions of your uploaded files:
  version :large do
    # Resize only if width is greater than 800px, maintaining aspect ratio
    process :resize_to_width_limit => 800
  end

  # Add a white list of extensions which are allowed to be uploaded.
  def extension_allowlist
    %w(jpg jpeg gif png)
  end

  # Override the filename of the uploaded files:
  def filename
    "proof_of_delivery_#{secure_token}.#{file.extension}" if original_filename.present?
  end

  protected

  def secure_token
    var = :"@#{mounted_as}_secure_token"
    model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.uuid)
  end
  
  private
  
  # Custom method to resize based on width only, maintaining aspect ratio
  def resize_to_width_limit(width)
    manipulate! do |img|
      if img.width > width
        img.resize "#{width}x"
      end
      img
    end
  end
end