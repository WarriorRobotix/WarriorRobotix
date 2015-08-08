class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      # Base
      t.string :type
      t.string :title
      t.text :description

      # Event
      t.datetime :start_at
      t.integer :status, default: 0, null: false

      # Poll
      t.string :options

      # Event/Poll
      t.datetime :end_at

      t.integer :restriction, default: 0, null: false
      t.belongs_to :author

      t.timestamps null: false
    end
  end
end
