require 'test_helper'

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "should get /" do
    get root_url
    assert_response :success
  end

  test "should get /vex" do
    get vex_url
    assert_response :success
  end

  test "should get /frc-ceta" do
    get frc_ceta_url
    assert_response :success
  end

  test "should get /mentors" do
    get mentors_url
    assert_response :success
  end

  test "should get /website" do
    get website_url
    assert_response :success
  end

  test "should get /photos" do
    get photos_url
    assert_response :success
  end

  test "should get /contact" do
    get contact_url
    assert_response :success
  end
end
