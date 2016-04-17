json.array!(@scouting_entries) do |scouting_entry|
  json.extract! scouting_entry, :id, :team_stat_id, :member_id, :extra_note, :rating, :drive_motors, :drive_motor_type, :drive_wheels, :drive_wheel_type, :drive_configuration, :drive_clearance, :shooter_type, :shooter_motors, :shooter_rpm, :intake_type, :intake_motors, :intake_motor_type, :intake_flip_capacity, :lift, :lift_motors, :lift_elevation, :lift_works, :driver_consistency, :driver_intelligence, :preloads_capacity, :shooter_consistency, :shooter_range, :autonomous_strategy, :autonomous_preload_points, :autonomous_field_points, :autonomous_reliability, :stalling, :connection_issues
  json.url scouting_entry_url(scouting_entry, format: :json)
end
