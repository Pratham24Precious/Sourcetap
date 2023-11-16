class Api::V1::RecruitersController < ApplicationController
  before_action :set_recruiter, only: [:show, :update, :destroy]

  def index
    @recruiters = Recruiter.all
    render json: @recruiters
  end

  def show
    render json: @recruiter
  end

  def create
    @recruiter = Recruiter.new(recruiter_params)
    if @recruiter.save
      render json: @recruiter, status: :created
    else
      render json: { errors: @recruiter.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @recruiter.update(recruiter_params)
      render json: @recruiter
    else
      render json: { errors: @recruiter.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @recruiter.destroy
    head :no_content
  end

  private

  def set_recruiter
    @recruiter = Recruiter.find(params[:id])
  end

  def recruiter_params
    params.require(:recruiter).permit(:name, :email, :company_name, :city, :mobile_no, :password)
  end
end
