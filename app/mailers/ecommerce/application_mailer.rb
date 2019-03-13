module Ecommerce
  class ApplicationMailer < ActionMailer::Base
    default from: "ExpatShop.pe <gg@expatshop.pe>"
    layout 'ecommerce/mailer'
  end
end
