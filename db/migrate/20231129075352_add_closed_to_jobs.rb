class AddClosedToJobs < ActiveRecord::Migration[7.0]
  def change
    add_column :jobs, :closed, :boolean, default: false
  end
end
