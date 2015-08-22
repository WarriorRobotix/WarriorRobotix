class CreatePhotoLocations < ActiveRecord::Migration
  def change
    create_table :photo_locations do |t|
      t.string :page, null: false, index: true
      t.string :location, null: false
      t.belongs_to :photo, index: true, foreign_key: true
      t.belongs_to :processed_photo, index: true, foreign_key: true
      t.integer :width, null: false
      t.integer :height, null: false

      t.timestamps null: false
    end
  end
end
