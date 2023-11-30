class Api::V1::Admin::AdminUsersController < ApplicationController
  before_action :set_admin_user, only: [:show, :update, :destroy]
  before_action :authorize_admin_request, only: [:index_jobs, :show_jobs, :index_recruiters, :show_recruiters, :index_experts, :show_experts]

  def index
    @admin_users = AdminUser.all
    render json: @admin_users
  end

  def show
    render json: @admin_user
  end

  def create
    @admin_user = AdminUser.new(admin_user_params)

    if @admin_user.save
      render json: @admin_user, status: :created
    else
      render json: { errors: @admin_user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @admin_user.update(admin_user_params)
      render json: @admin_user
    else
      render json: { errors: @admin_user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @admin_user.destroy
    head :no_content
  end

  def index_jobs
    @jobs = Job.all
    render json: @jobs
  end

  def show_jobs
    @job = Job.find(params[:id])
    render json: @job
  end

  def index_recruiters
    @recruiters = Recruiter.all
    render json: @recruiters
  end

  def show_recruiters
    @recruiter = Recruiter.find(params[:id])
    render json: @recruiter
  end

  def index_experts
    @experts = Expert.all
    render json: @experts
  end

  def show_experts
    @expert = Expert.find(params[:id])
    render json: @expert
  end

  private

  def set_admin_user
    @admin_user = AdminUser.find(params[:id])
  end

  def admin_user_params
    params.permit(:name, :email, :password)
  end

  def authorize_admin_request
    authorize_request
    return if performed?

    unless @current_user.is_a?(AdminUser)
      render json: { error: 'unauthorized' }, status: :unauthorized
    end
  end
end
