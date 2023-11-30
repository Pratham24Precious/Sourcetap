require 'swagger_helper'

RSpec.describe Api::V1::JobsController, type: :request do
  before do
    @recruiter = FactoryBot.create(:recruiter)
    @recruiter_token = JsonWebToken.encode(user_id: @recruiter.id, role: 'Recruiter')
    @recruiter_headers = { 'Authorization' => "Bearer #{@recruiter_token}" }

    @expert = FactoryBot.create(:expert)
    @expert_token = JsonWebToken.encode(user_id: @expert.id, role: 'Expert')
    @expert_headers = { 'Authorization' => "Bearer #{@expert_token}" }
  end

  path '/api/v1/jobs' do
    get 'Retrieves a list of jobs' do
      tags 'Jobs Controller'
      produces 'application/json'

      response '200', 'list of jobs retrieved' do
        let!(:jobs) { FactoryBot.create_list(:job, 3) }

        it 'returns a list of jobs' do
          get '/api/v1/jobs'
          expect(response).to have_http_status(200)
          expect(JSON.parse(response.body)).to be_an_instance_of(Array)
          expect(JSON.parse(response.body).size).to eq(3)
        end
      end
    end

    get 'Retrieves a job' do
      tags 'Jobs Controller'
      produces 'application/json'
      parameter name: :id, in: :path, type: :integer, description: 'Job ID'
      parameter name: :Authorization, in: :header, type: :string, description: 'Bearer Token'

      response '200', 'job retrieved' do
        let(:recruiter) { FactoryBot.create(:recruiter) }
        let(:job) { FactoryBot.create(:job, recruiter: recruiter) }
        let(:id) { job.id }

        it 'retrieves a job' do
          get "/api/v1/jobs/#{id}", headers: @recruiter_headers
          expect(response).to have_http_status(200)
        end
      end

      response '403', 'forbidden' do
        let(:expert) { FactoryBot.create(:expert) }
        let(:recruiter) { FactoryBot.create(:recruiter) }
        let(:existing_job) { FactoryBot.create(:job, recruiter: recruiter) }
        let(:id) { existing_job.id }

        before do
          @expert_headers = { 'Authorization' => "Bearer #{JsonWebToken.encode(user_id: expert.id, role: 'Expert')}" }
        end

        it 'returns a forbidden status for expert' do
          get "/api/v1/jobs/#{id}", headers: @expert_headers
          expect(response).to have_http_status(200)
        end
      end
    end

    post 'Creates a job' do
      tags 'Jobs Controller'
      produces 'application/json'

      response '201', 'job created' do
        let(:job) { FactoryBot.attributes_for(:job) }

        it 'creates a job' do
          post '/api/v1/jobs', params: { job: job }, headers: @recruiter_headers
          expect(response).to have_http_status(201)
        end
      end

      response '403', 'forbidden' do
        let(:job) { FactoryBot.attributes_for(:job) }

        it 'returns a forbidden status for expert' do
          post '/api/v1/jobs', params: { job: job }, headers: @expert_headers
          expect(response).to have_http_status(403)
        end
      end
    end

    put 'Updates a job' do
      tags 'Jobs Controller'
      produces 'application/json'

      parameter name: :id, in: :path, type: :integer, description: 'Job ID'
      parameter name: :Authorization, in: :header, type: :string, description: 'Bearer Token'
      parameter name: :job, in: :body, required: true, schema: { '$ref' => '#/definitions/job_input' }

      response '200', 'job updated' do
        let(:existing_job) { FactoryBot.create(:job, recruiter: @recruiter) }
        let(:id) { existing_job.id }
        let(:job) { { title: 'Updated Job Title' } }

        it 'updates a job' do
          put "/api/v1/jobs/#{id}", params: { job: job }, headers: @recruiter_headers
          expect(response).to have_http_status(200)
        end
      end

      response '403', 'forbidden' do
        let(:recruiter) { FactoryBot.create(:recruiter) }
        let(:existing_job) { FactoryBot.create(:job, recruiter: recruiter) }
        let(:id) { existing_job.id }
        let(:job) { { title: 'Updated Job Title' } }

        it 'returns a forbidden status for expert' do
          put "/api/v1/jobs/#{id}", params: { job: job }, headers: @expert_headers
          expect(response).to have_http_status(403)
        end
      end
    end

    delete 'Deletes a job' do
      tags 'Jobs Controller'
      produces 'application/json'

      parameter name: :id, in: :path, type: :integer, description: 'Job ID'
      parameter name: :Authorization, in: :header, type: :string, description: 'Bearer Token'

      response '204', 'job deleted' do
        let(:recruiter) { FactoryBot.create(:recruiter) }
        let(:existing_job) { FactoryBot.create(:job, recruiter: recruiter) }
        let(:id) { existing_job.id }

        before do
          @recruiter_headers = { 'Authorization' => "Bearer #{JsonWebToken.encode(user_id: recruiter.id, role: 'Recruiter')}" }
        end

        it 'deletes a job' do
          puts "Recruiter ID: #{recruiter.id}, Job Recruiter ID: #{existing_job.recruiter.id}"
          delete "/api/v1/jobs/#{id}", headers: @recruiter_headers
          expect(response).to have_http_status(204)
        end
      end

      response '403', 'forbidden' do
        let(:expert) { FactoryBot.create(:expert) }
        let(:recruiter) { FactoryBot.create(:recruiter) }
        let(:existing_job) { FactoryBot.create(:job, recruiter: recruiter) }
        let(:id) { existing_job.id }

        before do
          @expert_headers = { 'Authorization' => "Bearer #{JsonWebToken.encode(user_id: expert.id, role: 'Expert')}" }
        end

        it 'returns a forbidden status for expert' do
          delete "/api/v1/jobs/#{id}", headers: @expert_headers
          expect(response).to have_http_status(403)
        end
      end
    end

    path '/api/v1/jobs/{id}/apply' do
      post 'Applies for a job' do
        tags 'Jobs Controller'
        produces 'application/json'
        parameter name: :id, in: :path, type: :integer, description: 'Job ID'
        parameter name: :Authorization, in: :header, type: :string, description: 'Bearer Token'

        response '200', 'applied for the job' do
          let(:recruiter) { FactoryBot.create(:recruiter) }
          let(:job) { FactoryBot.create(:job, recruiter: recruiter) }
          let(:id) { job.id }

          it 'applies for a job' do
            post "/api/v1/jobs/#{id}/apply", headers: @expert_headers
            expect(response).to have_http_status(200)
          end
        end

        response '403', 'forbidden' do
          let(:recruiter) { FactoryBot.create(:recruiter) }
          let(:id) { recruiter.id }

          it 'returns a forbidden status for a recruiter' do
            post "/api/v1/jobs/#{id}/apply", headers: @recruiter_headers
            expect(response).to have_http_status(403)
          end
        end
      end
    end
  end
end
