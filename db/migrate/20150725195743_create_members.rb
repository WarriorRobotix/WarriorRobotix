class CreateMembers < ActiveRecord::Migration
  def change
    create_table :members do |t|
      t.string   :password_digest
      t.string   :remember_digest

      t.string   :full_name, null: false
      t.string   :title
      t.string   :team
      t.string   :email, null: false
      t.string   :student_number
      t.integer  :grade

      t.boolean  :accepted, default: true, null: false
      t.boolean  :admin, default: false, null: false
      t.integer  :year_of_graduation
      t.string   :extra_info

      t.string   :reset_password_digest
      t.datetime :reset_password_at

      t.timestamps null: false
    end

    add_index :members, :email, unique: true
    add_index :members, :student_number

  end
end
