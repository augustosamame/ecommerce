module Ecommerce
  class ApplicationMailer < ActionMailer::Base
    include Ecommerce::EmailTracking

    default from: "ExpatShop.pe <gg@expatshop.pe>"
    layout 'ecommerce/mailer'

    # Mail templates only exist for these locales, several without a
    # locale-less fallback. I18n.locale is thread-local and Sidekiq reuses
    # threads, so a leaked locale like :en (fallback chain [:en]) raised
    # ActionView::MissingTemplate on delivery. Coerce anything unsupported
    # to the default (es-PE) around every render.
    SUPPORTED_MAIL_LOCALES = [:"en-PE", :"es-PE"].freeze

    around_action :with_supported_locale

    private

    def with_supported_locale(&block)
      locale = SUPPORTED_MAIL_LOCALES.include?(I18n.locale) ? I18n.locale : I18n.default_locale
      I18n.with_locale(locale, &block)
    end
  end
end
