class Expert < ApplicationRecord
  searchkick word_middle: [:skills]
  has_secure_password
  has_and_belongs_to_many :jobs

  validates :email, presence: true, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :name, presence: true, uniqueness: true
  validates :password,
            length: { minimum: 6 },
            if: -> { new_record? || !password.nil? }

  def recommended_jobs(expert_id)
    @expert = Expert.find(expert_id)
    expert_skills = @expert.skills.split(', ').map(&:downcase)

    recommended_jobs_ids = Job.search(
      "*",
      where: {
        id: { not: expert_id },
      },
      order: { created_at: :desc },
      load: false
    ).select do |job|
      (job.skills_required.split(', ').map(&:downcase) & expert_skills).any?
    end.map(&:id)

    recommended_jobs = Job.where(id: recommended_jobs_ids).order(created_at: :desc)
    recommended_jobs
  end
end
