require 'rails_helper'

RSpec.describe Api::V1::ExpertLoginController, type: :request do
  before do
    @user = FactoryBot.create(:expert)
    @token = JsonWebToken.encode(user_id: @user.id, role: 'Expert')
    # request.headers['Authorization'] = @token
  end

  describe 'POST /api/v1/expert_login/login' do
    context 'when valid credentials are provided' do
      it 'returns a token and user information' do
        post '/api/v1/expert_login/login', params: { email: @user.email, password: 'password123' }
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)).to include('token', 'exp', 'user_id', 'role')
      end
    end

    context 'when invalid credentials are provided' do
      it 'returns unauthorized' do
        post '/api/v1/expert_login/login', params: { email: 'invalid@example.com', password: 'wrongpassword' }
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)).to include('error' => 'unauthorized')
      end
    end
  end

  describe 'POST /api/v1/expert_login/signup' do
    context 'when valid expert params are provided' do
      it 'creates a new expert and returns a token and user information' do
        user1 = FactoryBot.attributes_for(:expert)

        post '/api/v1/expert_login/signup', params: user1 #{ name: 'John Doe', email: 'new@example.com', password: 'newpassword', skills: 'Ruby', experience: '5', mobile_no: '1234567890', current_city: 'Example City' }

        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)).to include('token', 'exp', 'user_id', 'role')
      end
    end

    context 'when invalid expert params are provided' do
      it 'returns unprocessable entity' do
        post '/api/v1/expert_login/signup', params: { name: 'John Doe', email: 'invalidemail', password: 'short', skills: 'Ruby', experience: '5', mobile_no: '1234567890', current_city: 'Example City' }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to include('errors')
      end
    end
  end
end
