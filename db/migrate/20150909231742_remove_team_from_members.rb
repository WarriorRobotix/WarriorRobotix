class RemoveTeamFromMembers < ActiveRecord::Migration
  def change
    remove_column :members, :team
    add_column :members, :team_id, :integer
  end
end
