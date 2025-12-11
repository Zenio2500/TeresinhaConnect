class ReadersController < ApplicationController
    respond_to :json, :html

    before_action :authenticate_user!
    before_action :set_reader, only: %i[ show edit update destroy ]
    before_action :set_readers, only: %i[ index ]

    def index
      respond_to do |format|
        format.html
        format.json { respond_with(@readers) }
      end
    end

    def show
      respond_to do |format|
        format.html
        format.json { respond_with(@reader) }
      end
    end

    def new
      @reader = Reader.new
    end

    def edit
    end

    def create
      @reader = Reader.new(reader_params)
      respond_to do |format|
        if @reader.save
          format.html { redirect_to reader_path(@reader), notice: "Leitor criado com sucesso." }
          format.json { render json: @reader, status: :created }
        else
          format.html { render :new, status: :unprocessable_entity }
          format.json { render json: { errors: @reader.errors.full_messages }, status: :unprocessable_entity }
        end
      end
    end

    def update
      respond_to do |format|
        if @reader.update(reader_params)
          format.html { redirect_to reader_path(@reader), notice: "Leitor atualizado com sucesso." }
          format.json { render json: @reader, status: :ok }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: { errors: @reader.errors.full_messages }, status: :unprocessable_entity }
        end
      end
    end

    def destroy
      respond_to do |format|
        if @reader.destroy
          format.html { redirect_to readers_path, notice: "Leitor excluído com sucesso." }
          format.json { head :no_content }
        else
          format.html { redirect_to readers_path, alert: "Erro ao excluir leitor." }
          format.json { render json: { errors: @reader.errors.full_messages }, status: :unprocessable_entity }
        end
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
