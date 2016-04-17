class AddRatingToScoutingEntries < ActiveRecord::Migration
  def change
    add_column :scouting_entries, :rating, :integer
  end
end
