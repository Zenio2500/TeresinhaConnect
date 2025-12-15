class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  
  include Authentication
  
  before_action :authenticate_user!
end
