module Ecommerce
  module SessionInfo
    def self.current_session_currency
      Thread.current[:currency]
    end

    def self.current_session_currency=(currency)
      Thread.current[:currency] = currency
    end
  end
end
