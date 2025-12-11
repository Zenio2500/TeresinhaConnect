class HomeController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :index ]

  def index
    @users_count = User.count
    @pastorals_count = Pastoral.count
    @readers_count = Reader.count
    @grades_count = Grade.count
    @upcoming_grades = Grade.where("date >= ?", Date.today).order(date: :asc).limit(5)
    @current_user = User.find_by(id: session[:user_id])
  end
end
