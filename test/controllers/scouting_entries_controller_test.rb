require 'test_helper'

class ScoutingEntriesControllerTest < ActionController::TestCase
  setup do
    @scouting_entry = scouting_entries(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:scouting_entries)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create scouting_entry" do
    assert_difference('ScoutingEntry.count') do
      post :create, scouting_entry: { autonomous_field_points: @scouting_entry.autonomous_field_points, autonomous_preload_points: @scouting_entry.autonomous_preload_points, autonomous_reliability: @scouting_entry.autonomous_reliability, autonomous_strategy: @scouting_entry.autonomous_strategy, connection_issues: @scouting_entry.connection_issues, drive_clearance: @scouting_entry.drive_clearance, drive_configuration: @scouting_entry.drive_configuration, drive_motor_type: @scouting_entry.drive_motor_type, drive_motors: @scouting_entry.drive_motors, drive_wheel_type: @scouting_entry.drive_wheel_type, drive_wheels: @scouting_entry.drive_wheels, driver_consistency: @scouting_entry.driver_consistency, driver_intelligence: @scouting_entry.driver_intelligence, intake_flip_capacity: @scouting_entry.intake_flip_capacity, intake_motor_type: @scouting_entry.intake_motor_type, intake_motors: @scouting_entry.intake_motors, intake_type: @scouting_entry.intake_type, lift: @scouting_entry.lift, lift_elevation: @scouting_entry.lift_elevation, lift_motors: @scouting_entry.lift_motors, lift_works: @scouting_entry.lift_works, member_id: @scouting_entry.member_id, preloads_capacity: @scouting_entry.preloads_capacity, shooter_consistency: @scouting_entry.shooter_consistency, shooter_motors: @scouting_entry.shooter_motors, shooter_range: @scouting_entry.shooter_range, shooter_rpm: @scouting_entry.shooter_rpm, shooter_type: @scouting_entry.shooter_type, stalling: @scouting_entry.stalling, team_stat_id: @scouting_entry.team_stat_id }
    end

    assert_redirected_to scouting_entry_path(assigns(:scouting_entry))
  end

  test "should show scouting_entry" do
    get :show, id: @scouting_entry
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @scouting_entry
    assert_response :success
  end

  test "should update scouting_entry" do
    patch :update, id: @scouting_entry, scouting_entry: { autonomous_field_points: @scouting_entry.autonomous_field_points, autonomous_preload_points: @scouting_entry.autonomous_preload_points, autonomous_reliability: @scouting_entry.autonomous_reliability, autonomous_strategy: @scouting_entry.autonomous_strategy, connection_issues: @scouting_entry.connection_issues, drive_clearance: @scouting_entry.drive_clearance, drive_configuration: @scouting_entry.drive_configuration, drive_motor_type: @scouting_entry.drive_motor_type, drive_motors: @scouting_entry.drive_motors, drive_wheel_type: @scouting_entry.drive_wheel_type, drive_wheels: @scouting_entry.drive_wheels, driver_consistency: @scouting_entry.driver_consistency, driver_intelligence: @scouting_entry.driver_intelligence, intake_flip_capacity: @scouting_entry.intake_flip_capacity, intake_motor_type: @scouting_entry.intake_motor_type, intake_motors: @scouting_entry.intake_motors, intake_type: @scouting_entry.intake_type, lift: @scouting_entry.lift, lift_elevation: @scouting_entry.lift_elevation, lift_motors: @scouting_entry.lift_motors, lift_works: @scouting_entry.lift_works, member_id: @scouting_entry.member_id, preloads_capacity: @scouting_entry.preloads_capacity, shooter_consistency: @scouting_entry.shooter_consistency, shooter_motors: @scouting_entry.shooter_motors, shooter_range: @scouting_entry.shooter_range, shooter_rpm: @scouting_entry.shooter_rpm, shooter_type: @scouting_entry.shooter_type, stalling: @scouting_entry.stalling, team_stat_id: @scouting_entry.team_stat_id }
    assert_redirected_to scouting_entry_path(assigns(:scouting_entry))
  end

  test "should destroy scouting_entry" do
    assert_difference('ScoutingEntry.count', -1) do
      delete :destroy, id: @scouting_entry
    end

    assert_redirected_to scouting_entries_path
  end
end
