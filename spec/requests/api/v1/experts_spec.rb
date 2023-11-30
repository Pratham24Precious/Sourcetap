require 'swagger_helper'

describe 'Experts API' do
  path '/api/v1/experts' do
    get 'Retrieves a list of experts' do
      tags 'Experts'
      produces 'application/json'

      response '200', 'list of experts retrieved' do
        let!(:experts) { FactoryBot.create_list(:expert, 3) }

        it 'returns a list of experts' do
          get '/api/v1/experts'
          expect(response).to have_http_status(200)
          expect(JSON.parse(response.body)).to be_an_instance_of(Array)
          expect(JSON.parse(response.body).size).to eq(3)
        end
      end
    end

    post 'Creates an expert' do
      tags 'Experts'
      consumes 'application/json'
      parameter name: :expert, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          email: { type: :string },
          skills: { type: :string },
          experience: { type: :integer },
          mobile_no: { type: :string },
          current_city: { type: :string },
          password: { type: :string }
        },
        required: ['name', 'email', 'skills', 'experience', 'mobile_no', 'current_city', 'password']
      }

      response '201', 'expert created' do
        let(:expert) {
          {
            name: 'John',
            email: 'rjohn11@example.com',
            skills: 'Ruby',
            experience: "5",
            mobile_no: '1234567890',
            current_city: 'City',
            password: 'Test@123456'
          }
        }
        run_test!
      end

      response '422', 'invalid request' do
        let(:expert) { { name: 'John', email: 'john11@example.com' } }
        run_test!
      end
    end
  end

  path '/api/v1/experts/{id}' do
    get 'Retrieves an expert' do
      tags 'Experts'
      produces 'application/json'
      parameter name: :id, in: :path, type: :string

      response '200', 'expert found' do
        schema type: :object,
               properties: {
                 id: { type: :integer },
                 name: { type: :string },
                 email: { type: :string },
                 skills: { type: :string },
                 experience: { type: :integer },
                 mobile_no: { type: :string },
                 current_city: { type: :string }
               },
               required: ['id', 'name', 'email', 'skills', 'experience', 'mobile_no', 'current_city']

        let(:id) { Expert.create(name: 'John', email: 'john11@example.com', skills: 'Ruby', experience: 5, mobile_no: '1234567890', current_city: 'City', password: 'ppassword').id }
        run_test!
      end

      response '404', 'expert not found' do
        let(:id) { 'invalid' }
        run_test!
      end
    end

    put 'Updates an expert' do
      tags 'Experts'
      consumes 'application/json'
      parameter name: :id, in: :path, type: :string
      parameter name: :expert, in: :body, schema: {
        type: :object,
        properties: {
          name: { type: :string },
          email: { type: :string },
          skills: { type: :string },
          experience: { type: :integer },
          mobile_no: { type: :string },
          current_city: { type: :string },
          password: { type: :string }
        },
        required: ['name', 'email', 'skills', 'experience', 'mobile_no', 'current_city', 'password']
      }

      response '200', 'expert updated' do
        let(:id) { Expert.create(name: 'John', email: 'john11@example.com', skills: 'Ruby', experience: 5, mobile_no: '1234567890', current_city: 'City', password: 'password').id }
        let(:expert) { { name: 'Updatedd Name', email: 'updated11@example.com', skills: 'Python', experience: 8, mobile_no: '9876543210', current_city: 'Updated City', password: 'updatedd_password' } }
        run_test!
      end

      response '422', 'invalid request' do
        let(:id) { Expert.create(name: 'John', email: 'john11@example.com', skills: 'Ruby', experience: 5, mobile_no: '1234567890', current_city: 'City', password: 'ppassword').id }
        let(:expert) { { name: nil } }
        run_test!
      end
    end

    delete 'Deletes an expert' do
      tags 'Experts'
      parameter name: :id, in: :path, type: :string

      response '204', 'expert deleted' do
        let(:id) { Expert.create(name: 'John', email: 'john11@example.com', skills: 'Ruby', experience: 5, mobile_no: '1234567890', current_city: 'City', password: 'ppassword').id }
        run_test!
      end
    end
  end
end
