class AddShowDebugProfilerToMembers < ActiveRecord::Migration
  def change
    add_column :members, :show_debug_profiler, :boolean, default: false, null: false
  end
end
