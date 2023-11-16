class Job < ApplicationRecord
  belongs_to :recruiter
  has_and_belongs_to_many :experts
end