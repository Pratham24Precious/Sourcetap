require 'rails_helper'

RSpec.describe Api::V1::RecruiterLoginController, type: :request do
  before do
    @user = FactoryBot.create(:recruiter)
    @token = JsonWebToken.encode(user_id: @user.id, role: 'Recruiter')
    # request.headers['Authorization'] = @token
  end

  describe 'POST /api/v1/recruiter_login/login' do
    context 'when valid credentials are provided' do
      it 'returns a token and user information' do
        post '/api/v1/recruiter_login/login', params: { email: @user.email, password: 'password123' }
        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)).to include('token', 'exp', 'user_id', 'role')
      end
    end

    context 'when invalid credentials are provided' do
      it 'returns unauthorized' do
        post '/api/v1/recruiter_login/login', params: { email: 'invalid@example.com', password: 'wrongpassword' }
        expect(response).to have_http_status(:unauthorized)
        expect(JSON.parse(response.body)).to include('error' => 'unauthorized')
      end
    end
  end

  describe 'POST /api/v1/recruiter_login/signup' do
    context 'when valid recruiter params are provided' do
      it 'creates a new recruiter and returns a token and user information' do
        user1 = FactoryBot.attributes_for(:recruiter)

        post '/api/v1/recruiter_login/signup', params: user1 #{ name: 'John Doe', email: 'new@example.com', company_name: 'Example company', password: 'newpassword', mobile_no: '1234567890', city: 'Example City' }

        expect(response).to have_http_status(:created)
        expect(JSON.parse(response.body)).to include('token', 'exp', 'user_id', 'role')
      end
    end

    context 'when invalid recruiter params are provided' do
      it 'returns unprocessable entity' do
        post '/api/v1/recruiter_login/signup', params: { name: 'John Doe', email: 'invalidemail', company_name: 'Example company', password: 'short', mobile_no: '1234567890', city: 'Example City' }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)).to include('errors')
      end
    end
  end
end
