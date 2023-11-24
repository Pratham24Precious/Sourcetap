class Api::V1::JobsController < ApplicationController
  before_action :set_job, only: [:show, :update, :destroy]
  before_action :authorize_request, only: [:create, :update, :destroy, :apply]

  def index
    @jobs = Job.all
    render json: @jobs, each_serializer: JobSerializer
  end

  def show
    render json: @job, serializer: JobSerializer
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
      render json: @job, status: :created, serializer: JobSerializer
    else
      render json: { errors: @job.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if current_user.is_a?(Recruiter) && @job.recruiter_id == current_user.id
      if @job.update(job_params)
        render json: @job, serializer: JobSerializer
      else
        render json: { errors: @job.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: 'You are not authorized to update this job' }, status: :forbidden
    end
  end

  def destroy
    if current_user.is_a?(Recruiter) && @job.recruiter_id == current_user.id
      @job.destroy
      head :no_content
    else
      render json: { error: 'You are not authorized to delete this job' }, status: :forbidden
    end
  end

  def apply
    if current_user.is_a?(Expert)
      @job = Job.find(params[:id])

      @job.experts << current_user

      if @job.update(applied: true)
        render json: @job, status: :ok, serializer: JobSerializer
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
