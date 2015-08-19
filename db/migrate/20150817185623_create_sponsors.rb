class CreateSponsors < ActiveRecord::Migration
  def change
    create_table :sponsors do |t|
      t.string :name
      t.string :description
      t.string :image_link
      t.string :facebook_link
      t.string :twitter_link
      t.string :website_link

      t.timestamps null: false
    end
  end
end
