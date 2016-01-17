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

  test "should send contact message" do
    post contact_url, params: { message: { full_name: "Test Person", email: "test@example.com", body: "An important message" } }
    assert_redirected_to contact_path
  end

  test "shouldn't send contact message without full name" do
    post contact_url, params: { message: { full_name: "", email: "test@example.com", body: "An important message" } }
    assert_response :success
  end

  test "shouldn't send contact message without body" do
    post contact_url, params: { message: { full_name: "Test Person", email: "test@example.com", body: "" } }
    assert_response :success
  end
end
