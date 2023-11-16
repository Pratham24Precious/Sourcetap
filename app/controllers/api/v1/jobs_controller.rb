class Api::V1::JobsController < ApplicationController
  before_action :set_job, only: [:show, :update, :destroy]
  before_action :authorize_request, only: [:create, :update, :destroy, :apply]

  def index
    @jobs = Job.all
    render json: @jobs
  end

  def show
    render json: @job
  end

  def create
    @job = Job.new(job_params)

    if current_user.is_a?(Recruiter)
      @job.recruiter_id = current_user.id
    else
      render json: { error: 'Only recruiters can create jobs' }, status: :forbidden
      return
    end

    if @job.save
      render json: @job, status: :created
    else
      render json: { errors: @job.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @job.update(job_params)
      render json: @job
    else
      render json: { errors: @job.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @job.destroy
    head :no_content
  end

  def apply
    if current_user.is_a?(Expert)
      @job = Job.find(params[:id])

      if @job.update(applied: true)
        render json: @job, status: :ok
      else
        render json: { errors: @job.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: 'Only experts can apply for jobs' }, status: :forbidden
    end
  end

  private

  def current_user
    @current_user
  end

  def set_job
    @job = Job.find(params[:id])
  end

  def job_params
    params.require(:job).permit(:title, :description, :skills_required, :experience_level, :location, :salary_range, :application_deadline, :contact_email, :contact_phone, :applied, expert_ids: [])
  end
end
