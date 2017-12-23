require_dependency "ecommerce/application_controller"

module Ecommerce
  class Backoffice::ControlsController < Backoffice::BaseController
    before_action :set_backoffice_control, only: [:edit, :update]
    authorize_resource :class => "Ecommerce::Control" #we have to do this because controller and model do not have the same namespace

    # GET /backoffice/controls
    def index
      @backoffice_controls = Control.where(internal: false).order(:id)
    end

    def edit
    end

    # POST /backoffice/controls
    def update
      if @backoffice_control.update(backoffice_control_params)
        redirect_to backoffice_controls_path, notice: 'Controls were successfully updated.'
      else
        render :index, alert: 'Error updating Controls.'
      end
    end

    private
      def set_backoffice_control
        @backoffice_control = Control.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def backoffice_control_params
        params.require(:control).permit(:name, :text_value, :boolean_value, :integer_value, :float_value, :date_value)
      end
  end
end
