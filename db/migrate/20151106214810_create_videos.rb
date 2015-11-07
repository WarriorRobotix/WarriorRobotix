class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.string :title, null: false
      t.string :youtube_vid, null: false
      t.string :author
      t.date :upload_date, null: false

      t.timestamps null: false
    end
  end
end
