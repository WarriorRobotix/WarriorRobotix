require 'test_helper'

class CompetitionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @competition = competitions(:one)
    sign_in_as_admin
  end

  test "should get index" do
    get competitions_url
    assert_response :success
  end

  test "should get new" do
    get new_competition_url
    assert_response :success
  end

  test "should create competition" do
    assert_difference('Competition.count') do
      post competitions_url, params: { competition: { achievements: @competition.achievements, cover_image_link: @competition.cover_image_link, description: @competition.description, end_date: @competition.end_date, location: @competition.location, name: @competition.name, start_date: @competition.start_date } }
    end

    assert_redirected_to competitions_path
  end

  test "should show competition" do
    assert_raises(ActionController::RoutingError) do
      get competition_url(@competition)
    end
  end

  test "should get edit" do
    get edit_competition_url(@competition)
    assert_response :success
  end

  test "should update competition" do
    patch competition_url(@competition), params: { competition: { achievements: @competition.achievements, cover_image_link: @competition.cover_image_link, description: @competition.description, end_date: @competition.end_date, location: @competition.location, name: @competition.name, start_date: @competition.start_date } }
    assert_redirected_to competitions_path
  end

  test "should destroy competition" do
    assert_difference('Competition.count', -1) do
      delete competition_url(@competition)
    end

    assert_redirected_to competitions_path
  end
end
