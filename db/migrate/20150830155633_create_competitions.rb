class CreateCompetitions < ActiveRecord::Migration
  def change
    create_table :competitions do |t|
      t.string :name, null: false
      t.text :description
      t.string :location
      t.string :achievements
      t.string :cover_image_link
      t.date :start_date
      t.date :end_date
      t.boolean :count_down, null: false, default: false

      t.timestamps null: false
    end
  end
end
