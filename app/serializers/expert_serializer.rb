class ExpertSerializer < ActiveModel::Serializer
  attributes :id, :name, :email, :skills, :experience, :mobile_no, :current_city

  has_many :jobs
end
