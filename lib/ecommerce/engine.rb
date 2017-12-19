require 'dotenv-rails'
Dotenv.load('.env')

module Ecommerce
  class Engine < ::Rails::Engine
    isolate_namespace Ecommerce
    engine_name 'ecommerce'

    #to support generators like bootstrap scaffold generators
    config.generators do |g|
      g.templates.unshift File::expand_path('../../templates', __FILE__)
    end

  end
end
