module Authentication
  extend ActiveSupport::Concern

  included do
    helper_method :current_user, :user_signed_in?
  end

  def authenticate_user!
    unless user_signed_in?
      respond_to do |format|
        format.html { redirect_to login_path, alert: 'Você precisa fazer login para acessar esta página.' }
        format.json { render json: { error: 'Not authenticated' }, status: :unauthorized }
      end
    end
  end

  def current_user
    @current_user ||= begin
      if session[:user_id]
        User.find_by(id: session[:user_id])
      else
        authenticate_with_http_basic do |email, password|
          user = User.find_by(email: email)
          user if user&.authenticate(password)
        end
      end
    end
  end

  def user_signed_in?
    current_user.present?
  end
end
