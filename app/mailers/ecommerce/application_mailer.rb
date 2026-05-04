module Ecommerce
  class ApplicationMailer < ActionMailer::Base
    include Ecommerce::EmailTracking

    default from: "ExpatShop.pe <gg@expatshop.pe>"
    layout 'ecommerce/mailer'
  end
end
