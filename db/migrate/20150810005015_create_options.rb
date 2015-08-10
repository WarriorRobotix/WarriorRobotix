class CreateOptions < ActiveRecord::Migration
  def change
    create_table :options do |t|
      t.belongs_to :poll
      t.integer :ballots_count
      t.string :description

      t.timestamps null: false
    end
  end
end
