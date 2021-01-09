require_dependency "ecommerce/application_controller"

module Ecommerce
  class Backoffice::UsersController < Backoffice::BaseController
    before_action :set_backoffice_user, only: [:show, :edit, :update, :destroy, :user_points, :new_user_points]
    authorize_resource :class => "User" #we have to do this because controller and model do not have the same namespace

    # GET /backoffice/users
    def index
      @backoffice_users = User.all
    end


    # GET /backoffice/users/1
    def show
      @backoffice_addresses = Address.where(user_id: @backoffice_user.id)
    end

    # GET /backoffice/users/new
    def new
      @backoffice_user = User.new
      @backoffice_user.status = "active"
    end

    # GET /backoffice/users/1/edit
    def edit
    end

    # POST /backoffice/users
    def create
      @backoffice_user = User.new(backoffice_user_params)
      @backoffice_user.password = "123456"
      if @backoffice_user.save
        redirect_to backoffice_user_path(@backoffice_user), notice: 'User was successfully created.'
      else
        render :new
      end
    end

    # PATCH/PUT /backoffice/users/1
    def update
      if @backoffice_user.update(backoffice_user_params)
        redirect_to backoffice_user_path(@backoffice_user), notice: 'User was successfully updated.'
      else
        render :edit
      end
    end

    # DELETE /backoffice/users/1
    def destroy
      @backoffice_user.destroy
      redirect_to backoffice_users_url, notice: 'User was successfully destroyed.'
    end

    def new_user_points
      @points_transaction = PointsTransaction.new(user_id: @backoffice_user.id, tx_type: 'customer_service')
    end

    def create_user_points
      @points_transaction = PointsTransaction.new(user_id: params[:points_transaction][:hidden_user_id], tx_type: 'customer_service', points: params[:points_transaction][:points])
      if @points_transaction.save
        redirect_to backoffice_user_points_path(@points_transaction.user_id), notice: 'Points Record was successfully created.'
      else
        render :new
      end
    end

    def user_points
      @points_transactions = @backoffice_user.points_transactions.order(id: :desc)
    end

    def void_points
      @points_transaction = PointsTransaction.find(params[:id])
      if @points_transaction.active?
        ActiveRecord::Base.transaction do
          @points_transaction.update(status: 'inactive')
          PointsTransaction.create(user_id: @points_transaction.user_id, points: -@points_transaction.points, tx_type: 'void', tx_id: nil)
        end
      end
      redirect_to backoffice_user_points_path(@points_transaction.user_id)
    end

    private
      # Use callbacks to share common setup or constraints between actions.
      def set_backoffice_user
        @backoffice_user = User.find(params[:id])
      end

      # Only allow a trusted parameter "white list" through.
      def backoffice_user_params
        params.require(:user).permit(:first_name, :last_name, :phone, :username, :address, :doc_id, :avatar, :avatar_cache, :email, :role, :pricelist_id, :status, :points)
      end
  end
end
