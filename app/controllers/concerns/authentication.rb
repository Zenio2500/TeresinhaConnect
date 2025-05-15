module Authentication
  extend ActiveSupport::Concern

  included do
    helper_method :current_user, :user_signed_in?
  end

  def authenticate_user!
    unless user_signed_in?
      render json: { error: 'Not authenticated' }, status: :unauthorized
    end
  end

  def current_user
    @current_user ||= authenticate_with_http_basic do |email, password|
      user = User.find_by(email: email)
      user if user&.authenticate(password)
    end
  end

  def user_signed_in?
    current_user.present?
  end
end
