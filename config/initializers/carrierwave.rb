#require 'carrierwave'
#require 'carrierwave/storage/fog'
#require 'dotenv-rails'

#CarrierWave.configure do |config|

  #Dotenv::Railtie.load

  #config.fog_provider = 'fog/aws'

  #config.fog_credentials = {
  #  :provider               => 'AWS',
  #:aws_access_key_id      => ENV["S3_AWS_ACCESS_KEY_ID"] || "A12345",
  #:aws_secret_access_key  => ENV["S3_AWS_SECRET_ACCESS_KEY"] || "A12345"
  #}
  #config.fog_directory  = ENV["CARRIERWAVE_CONFIG_FOG_DIRECTORY"]
  #config.storage = :fog
#end
