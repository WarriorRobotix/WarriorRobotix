class ChangePreloadsCapacityInScoutingEntries < ActiveRecord::Migration
  def up
    change_column :scouting_entries, :preloads_capacity, :integer
  end

  def down
    change_column :scouting_entries, :preloads_capacity, :string
  end
end
