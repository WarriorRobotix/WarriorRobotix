class CreateOptions < ActiveRecord::Migration
  def change
    create_table :options do |t|
      t.belongs_to :poll
      t.integer :ballots_count, default: 0, null: false
      t.string :description

      t.timestamps null: false
    end
  end
end
