require 'test_helper'

class TeamsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @team = teams(:one)
    sign_in_as_admin
  end

  test "should get index" do
    get teams_url
    assert_response :success
  end

  test "should get team-editor" do
    get team_editor_url
    assert_response :success
  end

  test "should get new" do
    get new_team_url
    assert_response :success
  end

  test "should create team" do
    assert_difference('Team.count') do
      post teams_url, params: { team: { name: @team.name, image_link: @team.image_link } }
    end

    assert_redirected_to team_editor_url
  end

  test "shouldn't show single team" do
    #The only way to view team should be teams#index
    assert_raises(ActionController::RoutingError) do
      get team_url(@team)
    end
  end

  test "should get edit" do
    get edit_team_url(@team)
    assert_response :success
  end

  test "should update team" do
    patch team_url(@team), params: { team: { name: @team.name, image_link: @team.image_link } }
    assert_redirected_to team_editor_url
  end

  test "should destroy team" do
    assert_difference('Team.count', -1) do
      delete team_url(@team)
    end

    assert_redirected_to team_editor_url
  end
end
