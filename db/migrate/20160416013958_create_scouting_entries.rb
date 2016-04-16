class CreateScoutingEntries < ActiveRecord::Migration
  def change
    create_table :scouting_entries do |t|
      t.belongs_to :team_stat, index: true, foreign_key: true
      t.belongs_to :member, index: true, foreign_key: true

      t.text :extra_note

      t.integer :drive_motors
      t.string :drive_motor_type
      t.integer :drive_wheels
      t.string :drive_wheel_type
      t.string :drive_configuration
      t.string :drive_clearance

      t.string :shooter_type
      t.integer :shooter_motors
      t.integer :shooter_rpm

      t.string :intake_type
      t.integer :intake_motors
      t.string :intake_motor_type
      t.string :intake_flip_capacity

      t.string :lift
      t.integer :lift_motors
      t.string :lift_elevation
      t.string :lift_works

      t.string :driver_consistency
      t.string :driver_intelligence

      t.string :preloads_capacity
      t.string :shooter_consistency
      t.string :shooter_range

      t.string :autonomous_strategy
      t.integer :autonomous_preload_points
      t.integer :autonomous_field_points
      t.string :autonomous_reliability
      
      t.string :stalling
      t.string :connection_issues

      t.timestamps null: false
    end
  end
end
