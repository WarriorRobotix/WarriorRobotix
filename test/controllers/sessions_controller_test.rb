require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @admin = members(:admin)
    @member = members(:member)
    @faker = Member.new(student_number: "123", email: "faker@example.com")
  end

  test "should get new" do
    get signin_path
    assert_response :success
  end

  test "should get new redirect if member has already signined" do
    sign_in_as_member

    get signin_path
    assert_redirected_to root_path
  end

  test "should sign out" do
    sign_in_as_member

    delete signout_path
    assert_redirected_to root_path
  end

  test "shouldn't sign out if member never sign in" do
    delete signout_path
    assert_redirected_to root_path
  end

  test "should sign in admin" do
    post signin_url, params: { identifier: @admin.student_number, password: '123456' }
    assert_redirected_to root_path
  end

  test "should sign in admin with email" do
    post signin_url, params: { identifier: @admin.email, password: '123456' }
    assert_redirected_to root_path
  end

  test "should sign in member" do
    post signin_url, params: { identifier: @member.student_number, password: '123456' }
    assert_redirected_to root_path
  end

  test "shouldn't sign in faker" do
    post signin_url, params: { identifier: @faker.student_number, password: '123456' }
    assert_response :success
  end

  test "shouldn't sign in incorrect password" do
    post signin_url, params: { identifier: @admin.student_number, password: '654321' }
    assert_response :success
  end
end
