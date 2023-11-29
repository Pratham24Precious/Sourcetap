class JobSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :skills_required, :experience_level, :location, :salary_range, :application_deadline, :contact_email, :contact_phone, :applied, :closed

  belongs_to :recruiter
  has_many :experts
end
