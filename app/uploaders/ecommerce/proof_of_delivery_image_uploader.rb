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
  # Resize to 800px width while maintaining aspect ratio
  process resize_to_limit: [800, nil]

  # Create different versions of your uploaded files:
  version :large do
    # Resize to 800px width, height adjusts automatically to maintain aspect ratio
    process resize_to_limit: [800, nil]
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
end