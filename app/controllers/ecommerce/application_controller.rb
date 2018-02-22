#require_dependency "ecommerce/application_controller"

module Ecommerce

  class ApplicationController < ::ApplicationController
    protect_from_forgery with: :exception
    before_action :merge_abilities
    before_action :add_stretched_to_body_tag

    #these next line will change layout of views based on selected template
    layout "ecommerce/#{Ecommerce.ecommerce_layout}"

    def add_stretched_to_body_tag
      add_body_css_class('stretched') if Ecommerce.ecommerce_layout == 'canvas_ecommerce'
    end

    # Controllers can call this to add classes to the body tag
    def add_body_css_class(css_class)
      @body_css_classes ||= []
      @body_css_classes << css_class
    end

    def locale
      case params[:set_locale]
      when "English"
        session[:locale] = 'en-PE'
      when "Español"
        session[:locale] = 'es-PE'
      end
      redirect_to :root
    end

    private

    def merge_abilities
      current_ability.merge(Ecommerce::Ability.new(current_user))
    end
  end

end
