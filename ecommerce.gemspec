$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "ecommerce/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "ecommerce"
  s.version     = Ecommerce::VERSION
  s.authors     = ["Augusto Samame"]
  s.email       = ["augusto@devtechperu.com"]
  s.homepage    = "https://www.devtechperu.com"
  s.summary     = "Rails ecommerce engine for use in DevTechPeru projects"
  s.description = "Description of Ecommerce."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.1.1"
  s.add_dependency 'kaminari', "~> 1.1.1"

  s.add_development_dependency "pg"
end
