class CreateRecruiters < ActiveRecord::Migration[7.0]
  def change
    create_table :recruiters do |t|
      t.string :name
      t.string :email
      t.string :company_name
      t.string :city
      t.string :mobile_no
      t.string :password_digest

      t.timestamps
    end
  end
end
