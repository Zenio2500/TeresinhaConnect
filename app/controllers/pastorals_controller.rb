class PastoralsController < ApplicationController
  respond_to :json

  before_action :authenticate_user!
  before_action :set_pastoral, only: %i[ show update destroy ]
  before_action :set_pastorals, only: %i[ index ]

  def index
    respond_with(@pastorals)
  end

  def show
    respond_with(@pastoral)
  end

  def create
    @pastoral = Pastoral.new(pastoral_params)
    if @pastoral.save
      render json: @pastoral, status: :created
    else
      render json: { errors: @pastoral.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @pastoral.update(pastoral_params)
      render json: @pastoral, status: :ok
    else
      render json: { errors: @pastoral.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    if @pastoral.destroy
      head :no_content
    else
      render json: { errors: @pastoral.errors.full_messages }, status: :unprocessable_entity
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
    @pastorals = Pastoral.all
  end

  def pastoral_params
    params.require(:pastoral).permit(:name, :coordinator_id, :vice_coordinator_id, :description)
  end
end