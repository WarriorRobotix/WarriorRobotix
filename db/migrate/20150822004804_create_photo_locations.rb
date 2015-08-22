class CreatePhotoLocations < ActiveRecord::Migration
  def change
    create_table :photo_locations do |t|
      t.string :page, null: false, index: true
      t.string :location, null: false

      t.belongs_to :photo, index: true, foreign_key: true
      t.belongs_to :processed_photo, index: true, foreign_key: true

      t.integer :dimension_type, default: 0, null: false
      t.integer :width
      t.integer :height

      t.timestamps null: false
    end
  end
end
