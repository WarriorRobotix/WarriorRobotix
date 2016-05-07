class AddDurationFloatToAttendances < ActiveRecord::Migration
  def change
    add_column :attendances, :duration_float, :float, default: 0.0, null: false
  end

end
