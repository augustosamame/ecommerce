module Ecommerce
  class Environment
    #include EnvironmentExtension

    attr_accessor :preferences

    def initialize
      @preferences = Ecommerce::AppConfiguration.new
    end
  end
end
