module Ecommerce
  class Backoffice::BaseController < ApplicationController
    layout 'ecommerce/backoffice'

    check_authorization

    before_action :authorize_role
    before_action :set_default_locale

    def authorize_role
      raise CanCan::AccessDenied unless current_user.admin? || current_user.auxiliary? || current_user.driver?
    end

    def set_default_locale
      I18n.locale = session[:locale] || Ecommerce.backoffice_default_locale
    end

  end
end
