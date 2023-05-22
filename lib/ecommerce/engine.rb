require 'dotenv-rails'
Dotenv.load('.env')

module Ecommerce
  class Engine < ::Rails::Engine
    isolate_namespace Ecommerce
    engine_name 'ecommerce'

    config.before_initialize do
      config.i18n.load_path += Dir["#{Ecommerce::Engine.root}/config/locales/**/*.yml"]
    end

    #to set up main_app objects via decorators in engine
    config.to_prepare do
      Decorators.register! Engine.root, Rails.root
    end

    #to support generators like bootstrap scaffold generators
    config.generators do |g|
      g.templates.unshift File::expand_path('../../templates', __FILE__)
    end

    config.autoload_paths += %W(#{Ecommerce::Engine.root}/lib)

  end
end

begin
  require 'jquery-rails'
rescue LoadError
  puts "Ecommerce::Engine error: Please add the jquery-rails gem to your main application's Gemfile. The Ecommerce engine needs it in order to work properly."
  exit
end

begin
  require 'jquery-ui-rails'
rescue LoadError
  puts "Ecommerce::Engine error: Please add the jquery-ui-rails gem to your main application's Gemfile. The Ecommerce engine needs it in order to work properly."
  exit
end

begin
  require 'bootstrap-sass'
rescue LoadError
  puts "Ecommerce::Engine error: Please add the bootstrap-sass gem to your main application's Gemfile. The Ecommerce engine needs it in order to work properly."
  exit
end
