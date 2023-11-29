class EnableSearchkickForJobsAndExperts < ActiveRecord::Migration[7.0]
  def change
    add_column :jobs, :searchkick_index, :jsonb
    add_column :experts, :searchkick_index, :jsonb
  end
end
