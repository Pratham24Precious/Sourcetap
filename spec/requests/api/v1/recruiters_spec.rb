require 'swagger_helper'

describe 'Recruiters API' do
  path '/api/v1/recruiters' do
    get 'Retrieves a list of recruiters' do
      tags 'Recruiters'
      produces 'application/json'

      response '200', 'list of recruiters retrieved' do
        let!(:recruiters) { FactoryBot.create_list(:recruiter, 3) }

        it 'returns a list of recruiters' do
          get '/api/v1/recruiters'
          expect(response).to have_http_status(200)
          expect(JSON.parse(response.body)).to be_an_instance_of(Array)
          expect(JSON.parse(response.body).size).to eq(3)
        end
      end
    end

    post 'Creates a recruiter' do
      tags 'Recruiters'
      consumes 'application/json'
      parameter name: :recruiter, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          email: { type: :string },
          company_name: { type: :string },
          city: { type: :string },
          mobile_no: { type: :string },
          password: { type: :string }
        },
        required: ['name', 'email', 'company_name', 'city', 'mobile_no', 'password']
      }

      response '201', 'recruiter created' do
        let(:recruiter) { { name: 'created Name', email: 'created@example.com', company_name: 'created ABC Inc', city: 'created City', mobile_no: '9876543210', password: 'created_password' } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:recruiter) { { name: 'John Doe', email: 'john@example.com' } }
        run_test!
      end
    end
  end

  path '/api/v1/recruiters/{id}' do
    get 'Retrieves a recruiter' do
      tags 'Recruiters'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string

      response '200', 'recruiter found' do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 name: { type: :string },
                 email: { type: :string },
                 company_name: { type: :string },
                 city: { type: :string },
                 mobile_no: { type: :string }
               },
               required: ['id', 'name', 'email', 'company_name', 'city', 'mobile_no']

        let(:id) { Recruiter.create(name: 'John Doe', email: 'john@example.com', company_name: 'ABC Inc', city: 'City', mobile_no: '1234567890', password: 'password').id }
        run_test!
      end

      response '404', 'recruiter not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end

    put 'Updates a recruiter' do
      tags 'Recruiters'
      consumes 'application/json'
      parameter name: :id, in: :path, type: :string
      parameter name: :recruiter, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          email: { type: :string },
          company_name: { type: :string },
          city: { type: :string },
          mobile_no: { type: :string },
          password: { type: :string }
        },
        required: ['name', 'email', 'company_name', 'city', 'mobile_no', 'password']
      }

      response '200', 'recruiter updated' do
        let(:id) { Recruiter.create(name: 'John Doe', email: 'john@example.com', company_name: 'ABC Inc', city: 'City', mobile_no: '1234567890', password: 'password').id }
        let(:recruiter) { { name: 'Updated Name', email: 'updated@example.com', company_name: 'Updated ABC Inc', city: 'Updated City', mobile_no: '9876543210', password: 'updated_password' } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:id) { Recruiter.create(name: 'John Doe', email: 'john@example.com', company_name: 'ABC Inc', city: 'City', mobile_no: '1234567890', password: 'password').id }
        let(:recruiter) { { name: nil } }
        run_test!
      end
    end

    delete 'Deletes a recruiter' do
      tags 'Recruiters'
      parameter name: :id, in: :path, type: :string

      response '204', 'recruiter deleted' do
        let(:id) { Recruiter.create(name: 'John Doe', email: 'john@example.com', company_name: 'ABC Inc', city: 'City', mobile_no: '1234567890', password: 'password').id }
        run_test!
      end
    end
  end
end
