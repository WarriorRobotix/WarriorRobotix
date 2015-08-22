class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.string :name
      t.string :file
      t.string :external_link

      t.timestamps null: false
    end
  end
end
