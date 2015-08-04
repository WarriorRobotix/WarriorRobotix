class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.string :title
      t.text :description

      t.references :attachment, polymorphic: true, index: true

      t.integer :restriction, default: 0, null: false

      t.belongs_to :member

      t.timestamps null: false
    end
  end
end
