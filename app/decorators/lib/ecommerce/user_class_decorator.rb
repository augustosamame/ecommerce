module Lib
  module Ecommerce
    class UserClassDecorator
      def self.decorate
        if Ecommerce.user_class
          Ecommerce.decorate_user_class!
        else
          raise "Ecommerce.user_class must be set in main_app ecommerce.rb initializer"
        end
      end
    end
  end
end
