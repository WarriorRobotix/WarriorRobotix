class CreateTeamStats < ActiveRecord::Migration
  def change
    create_table :team_stats do |t|
      t.string :number
      t.string :team_name
      t.integer :robot_score
      t.integer :robot_rank
      t.integer :programming_score
      t.integer :programming_rank
      t.string :country
      t.string :city
      t.string :region

      t.timestamps null: false
    end
  end
end
