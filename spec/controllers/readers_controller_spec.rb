require 'rails_helper'

RSpec.describe ReadersController, type: :controller do
  let(:valid_attributes) do
    {
      reader: {
        user_id: create(:user).id,
        disponibility: ['Domingo 9h', 'Sábado 19h'],
        read_types: ['Primeira Leitura', 'Salmo']
      }
    }
  end

  let(:invalid_attributes) do
    {
      reader: {
        user_id: nil,
        disponibility: [],
        read_types: []
      }
    }
  end

  let(:user) { create(:user) }
  let!(:reader) { create(:reader, user: user) }

  before do
    request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(
      user.email, 'password123'
    )
  end

  describe 'GET #index' do
    it 'returns a successful response' do
      get :index, format: :json
      expect(response).to be_successful
    end

    it 'returns all readers' do
      get :index, format: :json
      expect(JSON.parse(response.body).size).to eq(1)
    end
  end

  describe 'GET #show' do
    context 'when reader exists' do
      it 'returns a successful response' do
        get :show, params: { id: reader.id }, format: :json
        expect(response).to be_successful
      end

      it 'returns the requested reader' do
        get :show, params: { id: reader.id }, format: :json
        expect(JSON.parse(response.body)['id']).to eq(reader.id)
      end
    end

    context 'when reader does not exist' do
      it 'returns not found' do
        get :show, params: { id: 0 }, format: :json
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      it 'creates a new reader' do
        expect {
          post :create, params: valid_attributes, format: :json
        }.to change(Reader, :count).by(1)
      end

      it 'returns a created status' do
        post :create, params: valid_attributes, format: :json
        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new reader' do
        expect {
          post :create, params: invalid_attributes, format: :json
        }.not_to change(Reader, :count)
      end

      it 'returns unprocessable entity status' do
        post :create, params: invalid_attributes, format: :json
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PATCH #update' do
    let(:new_attributes) do
      {
        reader: {
          disponibility: ['Domingo 19h'],
          read_types: ['Segunda Leitura', 'Oração dos Fiéis']
        }
      }
    end

    context 'with valid parameters' do
      it 'updates the requested reader' do
        patch :update, params: { id: reader.id }.merge(new_attributes), format: :json
        reader.reload
        expect(reader.disponibility).to eq(['Domingo 19h'])
      end

      it 'returns a successful response' do
        patch :update, params: { id: reader.id }.merge(new_attributes), format: :json
        expect(response).to be_successful
      end
    end

    context 'with invalid parameters' do
      it 'does not update the reader' do
        patch :update, params: { id: reader.id, reader: { user_id: nil } }, format: :json
        reader.reload
        expect(reader.user_id).not_to be_nil
      end

      it 'returns unprocessable entity status' do
        patch :update, params: { id: reader.id, reader: { user_id: nil } }, format: :json
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:reader_to_delete) { create(:reader) }

    it 'destroys the requested reader' do
      expect {
        delete :destroy, params: { id: reader_to_delete.id }, format: :json
      }.to change(Reader, :count).by(-1)
    end

    it 'returns a successful response' do
      delete :destroy, params: { id: reader_to_delete.id }, format: :json
      expect(response).to have_http_status(:no_content)
    end
  end

  context 'unauthenticated access' do
    before do
      request.env['HTTP_AUTHORIZATION'] = nil
    end

    it 'returns unauthorized' do
      get :index
      expect(response).to have_http_status(:unauthorized)
    end
  end
end