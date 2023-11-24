class Api::V1::ExpertsController < ApplicationController
  before_action :set_expert, only: [:show, :update, :destroy]

  def index
    @experts = Expert.all
    render json: @experts, each_serializer: ExpertSerializer
  end

  def show
    render json: @expert, serializer: ExpertSerializer
  end

  def create
    @expert = Expert.new(expert_params)
    if @expert.save
      render json: @expert, status: :created, serializer: ExpertSerializer
    else
      render json: { errors: @expert.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    if @expert.update(expert_params)
      render json: @expert, serializer: ExpertSerializer
    else
      render json: { errors: @expert.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @expert.destroy
    head :no_content
  end

  private

  def set_expert
    @expert = Expert.find(params[:id])
  end

  def expert_params
    params.permit(:name, :email, :skills, :experience, :mobile_no, :current_city, :password)
  end
end
