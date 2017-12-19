require 'dotenv-rails'
Dotenv.load('.env')

module Ecommerce
  class Engine < ::Rails::Engine
    isolate_namespace Ecommerce
    engine_name 'ecommerce'

  end
end
