class CreateJobs < ActiveRecord::Migration[7.0]
  def change
    create_table :jobs do |t|
      t.string :title
      t.text :description
      t.string :skills_required
      t.string :experience_level
      t.string :location
      t.string :salary_range
      t.date :application_deadline
      t.string :contact_email
      t.string :contact_phone
      t.boolean :applied, default: false
      t.references :recruiter, null: false, foreign_key: true

      t.timestamps
    end

    create_table :experts_jobs, id: false do |t|
      t.belongs_to :expert
      t.belongs_to :job
    end
  end
end
