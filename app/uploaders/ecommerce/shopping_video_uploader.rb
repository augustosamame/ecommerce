class Ecommerce::ShoppingVideoUploader < CarrierWave::Uploader::Base
  storage :fog

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  # include CarrierWave::MiniMagick

  # Choose what kind of storage to use for this uploader:
  #storage :file
  storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url(*args)
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  def cache_dir
    "#{Rails.root}/public/uploads/tmp"
#      "#{Rails.root}/tmp/uploads"
  end

  # Process files as they are uploaded:
  # process scale: [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  # version :thumb do
  #   process resize_to_fit: [50, 50]
  # end

#  def store_dimensions
#    if file && model
#      #will store image_dimensions in new model fields
#      model.product_image_width, model.product_image_height = ::MiniMagick::Image.open(file.file)[:dimensions]
#    end
#  end

  def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "wish_image.png"].compact.join('_'))
  #
  "https://s3.amazonaws.com/#{ENV['CARRIERWAVE_CONFIG_FOG_DIRECTORY']}/default-product-image.jpg"
  #  "/assets/fallback/" + [version_name, "wish-image.png"].compact.join('_')
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_allowlist
    %w(mp4 mov)
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

  #def filename
  #  "#{secure_token}.#{file.extension}" if original_filename.present?
  #end

  def filename
    if original_filename
      @name ||= "#{model.id}_#{timestamp}_#{super}"
    end
  end

  private

    def timestamp
      var = :"@#{mounted_as}_timestamp"
      model.instance_variable_get(var) or model.instance_variable_set(var, Time.now.to_i)
    end

    protected

    def secure_token
      var = :"@#{mounted_as}_secure_token"
      model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.uuid)
    end

end
