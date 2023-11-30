class Api::V1::RecruiterLoginController < ApplicationController
  before_action :authorize_request, except: [:login, :signup]

  def login
    recruiter = authenticate_user(params[:email], params[:password], 'Recruiter')

    if recruiter
      generate_token_and_render_response(recruiter, 'Recruiter')
    else
      render json: { error: 'unauthorized' }, status: :unauthorized
    end
  end

  def signup
    recruiter = Recruiter.new(recruiter_params)

    if recruiter.save
      generate_token_and_render_response(recruiter, 'Recruiter')
    else
      render json: { errors: recruiter.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def recruiter_params
    params.permit(:name, :email, :password, :company_name, :city, :mobile_no)
  end
end
