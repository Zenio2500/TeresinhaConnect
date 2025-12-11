class SessionsController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :new, :create, :destroy ]

  def new
    if session[:user_id]
      redirect_to dashboard_path, notice: "Você já está autenticado."
    end
  end

  def create
    user = User.find_by(email: params[:email])

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to dashboard_path, notice: "Login realizado com sucesso! Bem-vindo(a), #{user.name}."
    else
      flash.now[:alert] = "Email ou senha inválidos."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to login_path, notice: "Você saiu do sistema."
  end
end
