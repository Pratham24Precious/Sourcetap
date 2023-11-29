class Job < ApplicationRecord
  belongs_to :recruiter
  has_and_belongs_to_many :experts

  scope :active, -> { where(closed: false) }
  scope :recent, -> { order(created_at: :desc) }

  searchkick text_start: [:title, :description, :skills_required]
end
