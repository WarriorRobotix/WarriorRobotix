class CreatePhotoLocations < ActiveRecord::Migration
  def change
    create_table :photo_locations do |t|
      t.string :page, null: false, index: true
      t.string :location, null: false
      t.boolean :prefered_local, null: false, default: false

      t.belongs_to :photo, foreign_key: true
      t.belongs_to :processed_photo, class_name: 'Photo', foreign_key: true

      t.integer :dimension_restriction, default: 0, null: false
      t.integer :width
      t.integer :height

      t.timestamps null: false
    end
  end
end
