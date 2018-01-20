#require_dependency "ecommerce/application_controller"

module Ecommerce

  class ApplicationController < ::ApplicationController
    protect_from_forgery with: :exception
    
    before_action :merge_abilities

    layout "ecommerce/#{Ecommerce.ecommerce_layout}"

    # Controllers can call this to add classes to the body tag
    def add_body_css_class(css_class)
      @body_css_classes ||= []
      @body_css_classes << css_class
    end

    private

    def merge_abilities
      current_ability.merge(Ecommerce::Ability.new(current_user))
    end
  end

end
