class CreatePostsTeams < ActiveRecord::Migration
  def change
    create_table :posts_teams, id: false do |t|
      t.belongs_to :post, index: true, foreign_key: true, null: false
      t.belongs_to :team, index: true, foreign_key: true, null: false
    end
  end
end
