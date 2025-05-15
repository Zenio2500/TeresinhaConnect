class UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: [:create]
  before_action :set_user, only: %i[show update destroy]
  before_action :set_users, only: %i[index]

  def index
    render json: @users
  end

  def show
    render json: @user
  end

  def create
    @user = User.new(user_params)
    if @user.save
      render json: @user, status: :created
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @user.update(user_params)
      render json: @user, status: :ok
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    if @user.destroy
      head :no_content
    else
      render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = User.find_by(id: params[:id])
    render json: { error: 'User not found' }, status: :not_found unless @user
  end

  def set_users
    @users = User.all
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :is_coordinator)
  end
end