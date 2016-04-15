class AddActualOrderToTeamStats < ActiveRecord::Migration
  def change
    add_column :team_stats, :actual_order, :integer
  end
end
