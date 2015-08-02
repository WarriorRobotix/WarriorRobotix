class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title
      t.text :description

      t.integer :attachment_type
      t.integer :attachment_id

      t.integer :restriction, default: 0

      t.belongs_to :member

      t.timestamps null: false
    end
  end
end
