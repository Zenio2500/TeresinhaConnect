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
            format.json { render json: @pastoral, status: :created }
        else
            format.json do
                render json: { errors: @pastoral.errors.full_messages } , status: 403
            end
        end
    end

    def update
        if @pastoral.update(pastoral_params)
            format.json { render json: @pastoral, status: :ok }
        else
            format.json do
                render json: { errors: @pastoral.errors.full_messages } , status: 403
            end
        end
    end

    def destroy
        if @pastoral.destroy
            format.json { render json: @pastoral, status: :ok }
        else
            format.json do
                render json: { errors: @pastoral.errors.full_messages } , status: 403
            end
        end
    end

    private

    def set_pastoral
        @pastoral = Pastoral.find_by(id: params[:id])
    end

    def set_pastorals
        @pastorals = Pastoral.all
    end

    def pastoral_params
        params.require(:pastoral).permit(:name, :coordinator_id, :vice_coordinator_id, :description)
    end
end