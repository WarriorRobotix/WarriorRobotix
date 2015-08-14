class CreateRegistrationFields < ActiveRecord::Migration
  def change
    create_table :registration_fields do |t|
      t.string :title, null: false
      t.string :extra_info
      t.integer :input_type, default: 0, null: false
      t.boolean :optional, default: true, null: false
      t.integer :order, default: 0, null: false
      t.string :map_to

      t.timestamps null: false
    end
  end
end
