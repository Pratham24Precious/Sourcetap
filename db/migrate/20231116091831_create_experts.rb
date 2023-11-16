class CreateExperts < ActiveRecord::Migration[7.0]
  def change
    create_table :experts do |t|
      t.string :name
      t.string :email
      t.string :skills
      t.integer :experience
      t.string :mobile_no
      t.string :current_city
      t.string :password_digest

      t.timestamps
    end
  end
end
