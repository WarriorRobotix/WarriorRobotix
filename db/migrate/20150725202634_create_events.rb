class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :location

      t.belongs_to :post, index: true
      t.integer :restriction_level, default: 0

      t.datetime :start_at
      t.datetime :end_at

      t.timestamps null: false
    end
  end
end
