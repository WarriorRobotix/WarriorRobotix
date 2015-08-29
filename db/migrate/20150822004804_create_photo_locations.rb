class CreatePhotoLocations < ActiveRecord::Migration
  def change
    create_table :photo_locations do |t|
      t.string :page, null: false, index: true
      t.string :location, null: false
      t.boolean :prefered_local, null: false, default: false

      t.references :photo, foreign_key: true

      t.integer :dimension_restriction, default: 0, null: false
      t.integer :width
      t.integer :height

      t.timestamps null: false
    end
  end
end
