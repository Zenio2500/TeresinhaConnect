require 'rails_helper'

RSpec.describe GradesController, type: :controller do
  let(:valid_attributes) do
    {
      grade: {
        date: Date.tomorrow,
        is_solemnity: false,
        liturgical_color: 'Verde',
        liturgical_time: 'Tempo Comum',
        description: 'Descrição da grade'
      }
    }
  end

  let(:invalid_attributes) do
    {
      grade: {
        date: nil,
        liturgical_color: 'Azul',
        liturgical_time: '',
        description: ''
      }
    }
  end

  let(:user) { create(:user) }
  let!(:grade) { create(:grade) }

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

    it 'returns all grades' do
      get :index, format: :json
      expect(JSON.parse(response.body).size).to eq(1)
    end
  end

  describe 'GET #show' do
    context 'when grade exists' do
      it 'returns a successful response' do
        get :show, params: { id: grade.id }, format: :json
        expect(response).to be_successful
      end

      it 'returns the requested grade' do
        get :show, params: { id: grade.id }, format: :json
        expect(JSON.parse(response.body)['id']).to eq(grade.id)
      end
    end

    context 'when grade does not exist' do
      it 'returns not found' do
        get :show, params: { id: 0 }, format: :json
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      it 'creates a new grade' do
        expect {
          post :create, params: valid_attributes, format: :json
        }.to change(Grade, :count).by(1)
      end

      it 'returns a created status' do
        post :create, params: valid_attributes, format: :json
        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new grade' do
        expect {
          post :create, params: invalid_attributes, format: :json
        }.not_to change(Grade, :count)
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
        grade: {
          description: 'Nova descrição atualizada',
          liturgical_color: 'Branco'
        }
      }
    end

    context 'with valid parameters' do
      it 'updates the requested grade' do
        patch :update, params: { id: grade.id }.merge(new_attributes), format: :json
        grade.reload
        expect(grade.description).to eq('Nova descrição atualizada')
      end

      it 'returns a successful response' do
        patch :update, params: { id: grade.id }.merge(new_attributes), format: :json
        expect(response).to be_successful
      end
    end

    context 'with invalid parameters' do
      it 'does not update the grade' do
        patch :update, params: { id: grade.id, grade: { liturgical_color: 'Azul' } }, format: :json
        grade.reload
        expect(grade.liturgical_color).not_to eq('Azul')
      end

      it 'returns unprocessable entity status' do
        patch :update, params: { id: grade.id, grade: { liturgical_color: 'Azul' } }, format: :json
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:grade_to_delete) { create(:grade) }

    it 'destroys the requested grade' do
      expect {
        delete :destroy, params: { id: grade_to_delete.id }, format: :json
      }.to change(Grade, :count).by(-1)
    end

    it 'returns a successful response' do
      delete :destroy, params: { id: grade_to_delete.id }, format: :json
      expect(response).to have_http_status(:no_content)
    end
  end

  context 'unauthenticated access' do
    before do
      request.env['HTTP_AUTHORIZATION'] = nil
    end

    it 'returns unauthorized' do
      get :index
      expect(response).to have_http_status(:found)
    end
  end
end