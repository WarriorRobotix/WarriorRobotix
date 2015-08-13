class AddDurationToAttendance < ActiveRecord::Migration
  def change
    add_column :attendances, :duration, :datetime
  end
end
