class CreateAttendances < ActiveRecord::Migration
  def change
    create_table :attendances do |t|
      t.belongs_to :member, index: true, null: false

      t.belongs_to :event, index: true

      t.integer :status, default: 0, null: false

      t.datetime :start_at
      t.datetime :end_at

      t.timestamps null: false
    end
  end
end
