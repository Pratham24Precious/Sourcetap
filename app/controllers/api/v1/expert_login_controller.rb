class Api::V1::ExpertLoginController < ApplicationController
  before_action :authorize_request, except: [:login, :signup]

  def login
    expert = authenticate_user(params[:email], params[:password], 'Expert')

    if expert
      generate_token_and_render_response(expert, 'Expert')
    else
      render json: { error: 'unauthorized' }, status: :unauthorized
    end
  end

  def signup
    expert = Expert.new(expert_params)

    if expert.save
      generate_token_and_render_response(expert, 'Expert')
    else
      render json: { errors: expert.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def expert_params
    params.permit(:name, :email, :password, :skills, :experience, :mobile_no, :current_city)
  end
end
