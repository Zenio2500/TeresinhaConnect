class UsersController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :create, :new ]
  before_action :set_user, only: %i[show edit update destroy]
  before_action :set_users, only: %i[index]

  def index
    respond_to do |format|
      format.html
      format.json { render json: @users }
    end
  end

  def show
    respond_to do |format|
      format.html
      format.json { render json: @user }
    end
  end

  def new
    if session[:user_id]
      redirect_to dashboard_path, alert: "Você já está autenticado. Não é possível criar novos usuários enquanto estiver logado."
      return
    end
    @user = User.new
  end

  def edit
  end

  def create
    if session[:user_id]
      redirect_to dashboard_path, alert: "Você já está autenticado. Não é possível criar novos usuários enquanto estiver logado."
      return
    end

    @user = User.new(user_params)
    respond_to do |format|
      if @user.save
        format.html { redirect_to login_path, notice: "Usuário criado com sucesso. Faça login para continuar." }
        format.json { render json: @user, status: :created }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to user_path(@user), notice: "Usuário atualizado com sucesso." }
        format.json { render json: @user, status: :ok }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @user.destroy
        format.html { redirect_to users_path, notice: "Usuário excluído com sucesso." }
        format.json { head :no_content }
      else
        format.html { redirect_to users_path, alert: "Erro ao excluir usuário." }
        format.json { render json: { errors: @user.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_user
    @user = User.find_by(id: params[:id])
    render json: { error: "User not found" }, status: :not_found unless @user
  end

  def set_users
    @users = User.all.order(:name)
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
