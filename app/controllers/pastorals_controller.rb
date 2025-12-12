class PastoralsController < ApplicationController
  respond_to :json, :html

  before_action :authenticate_user!
  before_action :set_pastoral, only: %i[ show edit update destroy ]
  before_action :set_pastorals, only: %i[ index ]

  def index
    respond_to do |format|
      format.html
      format.json { respond_with(@pastorals) }
    end
  end

  def show
    # Adicionar estatísticas se for a pastoral Liturgia (case-insensitive)
    if @pastoral.name.downcase == "liturgia"
      @readers_count = Reader.count
      @grades_count = Grade.count
      @upcoming_grades = Grade.where("date >= ?", Date.today).order(date: :asc).limit(5)
    end
    
    respond_to do |format|
      format.html
      format.json { respond_with(@pastoral) }
    end
  end

  def new
    @pastoral = Pastoral.new
  end

  def edit
  end

  def create
    @pastoral = Pastoral.new(pastoral_params)
    respond_to do |format|
      if @pastoral.save
        format.html { redirect_to pastoral_path(@pastoral), notice: "Pastoral criada com sucesso." }
        format.json { render json: @pastoral, status: :created }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: { errors: @pastoral.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @pastoral.update(pastoral_params)
        format.html { redirect_to pastoral_path(@pastoral), notice: "Pastoral atualizada com sucesso." }
        format.json { render json: @pastoral, status: :ok }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: { errors: @pastoral.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @pastoral.destroy
        format.html { redirect_to pastorals_path, notice: "Pastoral excluída com sucesso." }
        format.json { head :no_content }
      else
        format.html { redirect_to pastorals_path, alert: "Erro ao excluir pastoral." }
        format.json { render json: { errors: @pastoral.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end

  private

  def set_pastoral
    @pastoral = Pastoral.find_by(id: params[:id])
    if @pastoral.nil?
      render json: { errors: "Pastoral não encontrada." }, status: :not_found
    end
  end

  def set_pastorals
    @pastorals = Pastoral.all.order(:name)
  end

  def pastoral_params
    params.require(:pastoral).permit(:name, :coordinator_id, :vice_coordinator_id, :description)
  end
end
