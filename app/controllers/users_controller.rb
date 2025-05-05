class UsersController < ApplicationController
    respond_to :json

    before_action :authenticate_user!
    before_action :set_user, only: %i[ show update destroy ]
    before_action :set_users, only: %i[ index ]

    def index
        respond_with(@users)
    end

    def show
        respond_with(@user)
    end

    def create
        @user = User.new(user_params)
        if @user.save
            format.json { render json: @user, status: :created }
        else
            format.json do
                render json: { errors: @user.errors.full_messages } , status: 403
            end
        end
    end

    def update
        if @user.update(user_params)
            format.json { render json: @user, status: :ok }
        else
            format.json do
                render json: { errors: @user.errors.full_messages } , status: 403
            end
        end
    end

    def destroy
        if @user.destroy
            format.json { render json: @user, status: :ok }
        else
            format.json do
                render json: { errors: @user.errors.full_messages } , status: 403
            end
        end
    end

    private

    def set_user
        @user = User.find_by(id: params[:id])
    end

    def set_users
        @users = User.all
    end

    def user_params
        params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end