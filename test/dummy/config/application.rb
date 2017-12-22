require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)
require "ecommerce"

module Dummy
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    config.action_controller.action_on_unpermitted_parameters = :raise

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end
