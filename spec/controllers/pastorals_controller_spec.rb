require 'rails_helper'

RSpec.describe PastoralsController, type: :controller do
  let(:valid_attributes) do
    {
      pastoral: {
        name: 'Nova Pastoral',
        description: 'Descrição da nova pastoral',
        coordinator_id: create(:user).id,
        vice_coordinator_id: create(:user).id
      }
    }
  end

  let(:invalid_attributes) do
    {
      pastoral: {
        name: '',
        description: '',
        coordinator_id: nil,
        vice_coordinator_id: nil
      }
    }
  end

  let(:user) { create(:user) }
  let!(:pastoral) { create(:pastoral) }

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

    it 'returns all pastorals' do
      get :index, format: :json
      expect(JSON.parse(response.body).size).to eq(1)
    end
  end

  describe 'GET #show' do
    context 'when pastoral exists' do
      it 'returns a successful response' do
        get :show, params: { id: pastoral.id }, format: :json
        expect(response).to be_successful
      end

      it 'returns the requested pastoral' do
        get :show, params: { id: pastoral.id }, format: :json
        expect(JSON.parse(response.body)['id']).to eq(pastoral.id)
      end
    end

    context 'when pastoral does not exist' do
      it 'returns not found' do
        get :show, params: { id: 0 }, format: :json
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      it 'creates a new pastoral' do
        expect {
          post :create, params: valid_attributes, format: :json
        }.to change(Pastoral, :count).by(1)
      end

      it 'returns a created status' do
        post :create, params: valid_attributes, format: :json
        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new pastoral' do
        expect {
          post :create, params: invalid_attributes, format: :json
        }.not_to change(Pastoral, :count)
      end

      it 'returns unprocessable entity status' do
        post :create, params: invalid_attributes, format: :json
        expect(response).to have_http_status(:unprocessable_entity)
      end

      context 'when coordinator and vice_coordinator are the same' do
        let(:user) { create(:user) }
        let(:same_user_attributes) do
          {
            pastoral: {
              name: 'Pastoral com coordenadores iguais',
              description: 'Descrição',
              coordinator_id: user.id,
              vice_coordinator_id: user.id
            }
          }
        end

        it 'does not create a new pastoral' do
          expect {
            post :create, params: same_user_attributes, format: :json
          }.not_to change(Pastoral, :count)
        end

        it 'returns unprocessable entity status' do
          post :create, params: same_user_attributes, format: :json
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'returns an error message' do
          post :create, params: same_user_attributes, format: :json
          json_response = JSON.parse(response.body)
          expect(json_response['errors']).to include('Coordenador não pode ser o mesmo que o vice-coordenador.')
        end
      end
    end
  end

  describe 'PATCH #update' do
    let(:new_attributes) do
      {
        pastoral: {
          name: 'Pastoral Atualizada',
          description: 'Nova descrição'
        }
      }
    end

    context 'with valid parameters' do
      it 'updates the requested pastoral' do
        patch :update, params: { id: pastoral.id }.merge(new_attributes), format: :json
        pastoral.reload
        expect(pastoral.name).to eq('Pastoral Atualizada')
      end

      it 'returns a successful response' do
        patch :update, params: { id: pastoral.id }.merge(new_attributes), format: :json
        expect(response).to be_successful
      end
    end

    context 'with invalid parameters' do
      it 'does not update the pastoral' do
        patch :update, params: { id: pastoral.id, pastoral: { name: '' } }, format: :json
        pastoral.reload
        expect(pastoral.name).not_to eq('')
      end

      it 'returns unprocessable entity status' do
        patch :update, params: { id: pastoral.id, pastoral: { name: '' } }, format: :json
        expect(response).to have_http_status(:unprocessable_entity)
      end

      context 'when trying to set coordinator and vice_coordinator to the same user' do
        let(:user) { create(:user) }
        let(:same_user_attributes) do
          {
            pastoral: {
              coordinator_id: user.id,
              vice_coordinator_id: user.id
            }
          }
        end

        it 'does not update the pastoral' do
          expect {
            patch :update, params: { id: pastoral.id }.merge(same_user_attributes), format: :json
            pastoral.reload
          }.not_to change { pastoral.coordinator_id }
        end

        it 'returns unprocessable entity status' do
          patch :update, params: { id: pastoral.id }.merge(same_user_attributes), format: :json
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it 'returns an error message' do
          patch :update, params: { id: pastoral.id }.merge(same_user_attributes), format: :json
          json_response = JSON.parse(response.body)
          expect(json_response['errors']).to include('Coordenador não pode ser o mesmo que o vice-coordenador.')
        end
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:pastoral_to_delete) { create(:pastoral) }

    it 'destroys the requested pastoral' do
      expect {
        delete :destroy, params: { id: pastoral_to_delete.id }, format: :json
      }.to change(Pastoral, :count).by(-1)
    end

    it 'returns a successful response' do
      delete :destroy, params: { id: pastoral_to_delete.id }, format: :json
      expect(response).to be_successful
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