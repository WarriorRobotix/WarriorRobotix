class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title
      t.text :description

      t.integer :content_type
      
      t.integer :restriction_level, default: 0

      t.belongs_to :member

      t.timestamps null: false
    end
  end
end
