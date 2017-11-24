#require_dependency "ecommerce/application_controller"

module Ecommerce

  class ApplicationController < ::ApplicationController
    before_action :merge_abilities

    layout "ecommerce/#{Ecommerce.ecommerce_layout}"

    private

    def merge_abilities
      current_ability.merge(Ecommerce::Ability.new(current_user))
    end
  end

end
