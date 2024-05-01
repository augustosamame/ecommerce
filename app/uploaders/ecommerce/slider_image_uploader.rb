class Ecommerce::SliderImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

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

  #version :thumb_120, :if => :is_image?, from_version: :large_1200 do
    #if image.content_type == "image/gif"
   #   gif_safe_transform! do |image|
   #     image.resize "#{120}x#{120}" # Perform any transformations here.
   #   end
    #else
    #  process resize_to_limit: [120, 120]
    #end

  #end

def is_image? picture
  if picture.content_type
    return picture.content_type.include? 'image' 
  else
    return false
  end
end

def gif_safe_transform!
  MiniMagick::Tool::Convert.new do |image|
    image << @file.path
    image.coalesce # Remove optimizations so each layer shows the full image.

    yield image

    image.layers "Optimize" # Re-optimize the image.
    image << @file.path
  end
end

  def fog_attributes
    {'Cache-Control' => "public, max-age=#{365.days.to_i}"}
  end

#  def store_dimensions
#    if file && model
#      #will store image_dimensions in new model fields
#      model.homepage_cat_image_width, model.homepage_cat_image_height = ::MiniMagick::Image.open(file.file)[:dimensions]
#    end
#  end

  def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "wish_image.png"].compact.join('_'))
  #
  "https://s3.amazonaws.com/#{ENV['CARRIERWAVE_CONFIG_FOG_DIRECTORY']}/default-category-image.jpg"
  #  "/assets/fallback/" + [version_name, "wish-image.png"].compact.join('_')
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_whitelist
    %w(jpg jpeg gif png mp4)
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  # def filename
  #   "something.jpg" if original_filename
  # end

end
