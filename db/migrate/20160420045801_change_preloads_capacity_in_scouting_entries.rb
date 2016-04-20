class ChangePreloadsCapacityInScoutingEntries < ActiveRecord::Migration
  def up
    change_column :scouting_entries, :preloads_capacity, 'integer USING CAST(preloads_capacity AS integer)'
  end

  def down
    change_column :scouting_entries, :preloads_capacity, 'string USING CAST(preloads_capacity AS string)'
  end
end
