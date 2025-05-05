class GradesController < ApplicationController
    respond_to :json

    before_action :authenticate_user!
    before_action :set_grade, only: %i[ show update destroy ]
    before_action :set_grades, only: %i[ index ]

    def index
        respond_with(@grades)
    end

    def show
        respond_with(@grade)
    end

    def create
        @grade = Grade.new(grade_params)
        if @grade.save
            format.json { render json: @grade, status: :created }
        else
            format.json do
                render json: { errors: @grade.errors.full_messages } , status: 403
            end
        end
    end

    def update
        if @grade.update(grade_params)
            format.json { render json: @grade, status: :ok }
        else
            format.json do
                render json: { errors: @grade.errors.full_messages } , status: 403
            end
        end
    end

    def destroy
        if @grade.destroy
            format.json { render json: @grade, status: :ok }
        else
            format.json do
                render json: { errors: @grade.errors.full_messages } , status: 403
            end
        end
    end

    private

    def set_grade
        @grade = Grade.find_by(id: params[:id])
    end

    def set_grades
        @grades = Grade.all
    end

    def grade_params
        params.require(:grade).permit(:date, :is_solemnity, :liturgical_color, :liturgical_time, :description)
    end
end