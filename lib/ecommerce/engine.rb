require 'kaminari'
require 'ecommerce/environment'

module Ecommerce
  class Engine < ::Rails::Engine
    isolate_namespace Ecommerce
    engine_name 'ecommerce'

    def self.root
      @root ||= Pathname.new(File.expand_path('../../../../', __FILE__))
    end

    initializer "ecommerce.environment", :before => :load_config_initializers do |app|
      app.config.ecommerce = Ecommerce::Environment.new
      Ecommerce::Config = app.config.ecommerce.preferences
    end

  end
end
