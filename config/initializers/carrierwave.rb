require 'carrierwave'
require 'carrierwave/storage/fog'
require 'dotenv-rails'

CarrierWave.configure do |config|

  Dotenv::Railtie.load

  config.fog_provider = 'fog/aws'
  config.asset_host = "https://#{ENV['CLOUDFRONT_DOMAIN']}"

  config.fog_credentials = {
  :provider               => 'AWS',
  :aws_access_key_id      => ENV["S3_AWS_ACCESS_KEY_ID"] || "A12345",
  :aws_secret_access_key  => ENV["S3_AWS_SECRET_ACCESS_KEY"] || "A12345"
  }
  config.fog_directory  = ENV["CARRIERWAVE_CONFIG_FOG_DIRECTORY"]
  config.fog_attributes = { 'Cache-Control' => "public, max-age=#{1.year.to_i}" }
  config.storage = :fog
end
