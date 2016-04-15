class AddDivisionToTeamStats < ActiveRecord::Migration
  def change
    add_reference :team_stats, :division, index: true, foreign_key: true
  end
end
