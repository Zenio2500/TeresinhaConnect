require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:valid_attributes) do
    {
      user: {
        name: 'Test User',
        email: 'test@example.com',
        password: 'password123',
        password_confirmation: 'password123'
      }
    }
  end

  let(:invalid_attributes) do
    {
      user: {
        name: '',
        email: '',
        password: '123',
        password_confirmation: '456'
      }
    }
  end

  let(:user) { create(:user, password: 'password123') }
  let(:coordinator_user) { create(:user, :coordinator, password: 'password123') }

  before do
    request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials(
      user.email, 'password123'
    )
  end

  describe 'GET #index' do
    let!(:users) { create_list(:user, 3) }

    it 'returns a successful response' do
      get :index, format: :json
      expect(response).to be_successful
    end

    it 'returns all users' do
      get :index, format: :json
      expect(JSON.parse(response.body).size).to eq(4) # 3 created + 1 signed in user
    end
  end

  describe 'GET #show' do
    context 'when user exists' do
      it 'returns a successful response' do
        get :show, params: { id: user.id }, format: :json
        expect(response).to be_successful
      end

      it 'returns the requested user' do
        get :show, params: { id: user.id }, format: :json
        expect(JSON.parse(response.body)['id']).to eq(user.id)
      end
    end

    context 'when user does not exist' do
      it 'returns not found' do
        get :show, params: { id: 0 }, format: :json
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      it 'creates a new user' do
        expect {
          post :create, params: valid_attributes, format: :json
        }.to change(User, :count).by(1)
      end

      it 'returns a created status' do
        post :create, params: valid_attributes, format: :json
        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new user' do
        expect {
          post :create, params: invalid_attributes, format: :json
        }.not_to change(User, :count)
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
        user: {
          name: 'Updated Name',
          email: 'updated@example.com'
        }
      }
    end

    context 'with valid parameters' do
      it 'updates the requested user' do
        patch :update, params: { id: user.id }.merge(new_attributes), format: :json
        user.reload
        expect(user.name).to eq('Updated Name')
      end

      it 'returns a successful response' do
        patch :update, params: { id: user.id }.merge(new_attributes), format: :json
        expect(response).to be_successful
      end
    end

    context 'with invalid parameters' do
      it 'does not update the user' do
        patch :update, params: { id: user.id, user: { email: '' } }, format: :json
        user.reload
        expect(user.email).not_to eq('')
      end

      it 'returns unprocessable entity status' do
        patch :update, params: { id: user.id, user: { email: '' } }, format: :json
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE #destroy' do
    let!(:user_to_delete) { create(:user) }

    it 'destroys the requested user' do
      expect {
        delete :destroy, params: { id: user_to_delete.id }, format: :json
      }.to change(User, :count).by(-1)
    end

    it 'returns a successful response' do
      delete :destroy, params: { id: user_to_delete.id }, format: :json
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