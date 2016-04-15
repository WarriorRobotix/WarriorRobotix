require 'test_helper'

class TeamStatsControllerTest < ActionController::TestCase
  setup do
    @team_stat = team_stats(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:team_stats)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create team_stat" do
    assert_difference('TeamStat.count') do
      post :create, team_stat: { city: @team_stat.city, country: @team_stat.country, number: @team_stat.number, programming_rank: @team_stat.programming_rank, programming_score: @team_stat.programming_score, region: @team_stat.region, robot_rank: @team_stat.robot_rank, robot_score: @team_stat.robot_score, team_name: @team_stat.team_name }
    end

    assert_redirected_to team_stat_path(assigns(:team_stat))
  end

  test "should show team_stat" do
    get :show, id: @team_stat
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @team_stat
    assert_response :success
  end

  test "should update team_stat" do
    patch :update, id: @team_stat, team_stat: { city: @team_stat.city, country: @team_stat.country, number: @team_stat.number, programming_rank: @team_stat.programming_rank, programming_score: @team_stat.programming_score, region: @team_stat.region, robot_rank: @team_stat.robot_rank, robot_score: @team_stat.robot_score, team_name: @team_stat.team_name }
    assert_redirected_to team_stat_path(assigns(:team_stat))
  end

  test "should destroy team_stat" do
    assert_difference('TeamStat.count', -1) do
      delete :destroy, id: @team_stat
    end

    assert_redirected_to team_stats_path
  end
end
