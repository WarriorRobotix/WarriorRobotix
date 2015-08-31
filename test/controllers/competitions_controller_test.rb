require 'test_helper'

class CompetitionsControllerTest < ActionController::TestCase
=begin
  setup do
    @competition = competitions(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:competitions)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create competition" do
    assert_difference('Competition.count') do
      post :create, competition: { achievements: @competition.achievements, cover_image_link: @competition.cover_image_link, description: @competition.description, end_date: @competition.end_date, location: @competition.location, name: @competition.name, start_date: @competition.start_date }
    end

    assert_redirected_to competition_path(assigns(:competition))
  end

  test "should show competition" do
    get :show, id: @competition
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @competition
    assert_response :success
  end

  test "should update competition" do
    patch :update, id: @competition, competition: { achievements: @competition.achievements, cover_image_link: @competition.cover_image_link, description: @competition.description, end_date: @competition.end_date, location: @competition.location, name: @competition.name, start_date: @competition.start_date }
    assert_redirected_to competition_path(assigns(:competition))
  end

  test "should destroy competition" do
    assert_difference('Competition.count', -1) do
      delete :destroy, id: @competition
    end

    assert_redirected_to competitions_path
  end
=end
end
