class ReadersController < ApplicationController
    respond_to :json

    before_action :authenticate_user!
    before_action :set_reader, only: %i[ show update destroy ]
    before_action :set_readers, only: %i[ index ]

    def index
        respond_with(@readers)
    end

    def show
        respond_with(@reader)
    end

    def create
      @reader = Reader.new(reader_params)
      if @reader.save
        render json: @reader, status: :created
      else
        render json: { errors: @reader.errors.full_messages }, status: :unprocessable_entity
      end
    end
    
    def update
      if @reader.update(reader_params)
        render json: @reader, status: :ok
      else
        render json: { errors: @reader.errors.full_messages }, status: :unprocessable_entity
      end
    end
    
    def destroy
      if @reader.destroy
        head :no_content
      else
        render json: { errors: @reader.errors.full_messages }, status: :unprocessable_entity
      end
    end

    private

    def set_reader
      @reader = Reader.find_by(id: params[:id])
      if @reader.nil?
        render json: { errors: "Leitor não encontrado." }, status: :not_found
      end
    end

    def set_readers
        @readers = Reader.all
    end

    def reader_params
        params.require(:reader).permit(:user_id, disponibility: [], read_types: [])
    end
end