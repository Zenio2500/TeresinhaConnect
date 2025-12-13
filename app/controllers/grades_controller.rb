class GradesController < ApplicationController
    respond_to :json, :html

    before_action :authenticate_user!
    before_action :set_grade, only: %i[ show edit update destroy add_reader remove_reader ]
    before_action :set_grades, only: %i[ index ]

    def index
      @readers = Reader.includes(:user).all
      respond_to do |format|
        format.html
        format.json { respond_with(@grades) }
      end
    end

    def show
      respond_to do |format|
        format.html
        format.json { respond_with(@grade) }
      end
    end

    def new
      @grade = Grade.new
    end

    def edit
    end

    def create
      @grade = Grade.new(grade_params)
      respond_to do |format|
        if @grade.save
          format.html { redirect_to grade_path(@grade), notice: "Escala criada com sucesso." }
          format.json { render json: @grade, status: :created }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: { errors: @grade.errors.full_messages }, status: :unprocessable_entity }
        end
      end
    end

    def update
      respond_to do |format|
        if @grade.update(grade_params)
          format.html { redirect_to grade_path(@grade), notice: "Escala atualizada com sucesso." }
          format.json { render json: @grade, status: :ok }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: { errors: @grade.errors.full_messages }, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      respond_to do |format|
        if @grade.destroy
          format.html { redirect_to grades_path, notice: "Escala excluída com sucesso." }
          format.json { head :no_content }
        else
          format.html { redirect_to grades_path, alert: "Erro ao excluir escala." }
          format.json { render json: { errors: @grade.errors.full_messages }, status: :unprocessable_entity }
        end
      end
    end

    def add_reader
      reader = Reader.find_by(id: params[:reader_id])
      reader_type = params[:reader_type]

      if reader.nil?
        render json: { error: "Leitor não encontrado" }, status: :not_found
        return
      end

      reader_grade = @grade.reader_grades.build(reader: reader, reader_type: reader_type)
      
      if reader_grade.save
        first_name = reader.user.name.split.first
        render json: { 
          success: true, 
          reader_grade: {
            id: reader_grade.id,
            reader_id: reader.id,
            reader_name: first_name,
            reader_type: reader_type
          }
        }, status: :created
      else
        render json: { error: reader_grade.errors.full_messages.join(", ") }, status: :unprocessable_entity
      end
    end

    def remove_reader
      reader_grade = @grade.reader_grades.find_by(id: params[:reader_grade_id])
      
      if reader_grade.nil?
        render json: { error: "Associação não encontrada" }, status: :not_found
        return
      end

      reader_id = reader_grade.reader_id
      
      if reader_grade.destroy
        render json: { 
          success: true,
          reader_id: reader_id
        }, status: :ok
      else
        render json: { error: "Erro ao remover leitor" }, status: :unprocessable_entity
      end
    end

    private

    def set_grade
      @grade = Grade.find_by(id: params[:id])
      if @grade.nil?
        render json: { errors: "Escala não encontrada." }, status: :not_found
      end
    end

    def set_grades
      @grades = Grade.all
    end

    def grade_params
      params.require(:grade).permit(:date, :is_solemnity, :liturgical_color, :liturgical_time, :description)
    end
end
