require 'test_helper'

class MembersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @member = members(:member)
    sign_in_as_admin
  end

  test "should get index" do
    get members_url
    assert_response :success
  end

  test "should get new" do
    get new_member_url
    assert_response :success
  end

  test "should create member" do
    assert_difference('Member.count') do
      post members_url, params: { member: { accepted: @member.accepted, admin: @member.admin, email: "second.member@example.com", first_name: "Second", grade: @member.grade, graduated_year: @member.graduated_year, last_name: "Example", student_number: "333", title: @member.title } }
    end

    assert_redirected_to members_path
  end

  test "should show member" do
    get member_url(@member)
    assert_response :success
  end

  test "should get edit" do
    get edit_member_url(@member)
    assert_response :success
  end

  test "should update member" do
    patch member_url(@member), params: { member: { accepted: @member.accepted, admin: @member.admin, email: @member.email, first_name: @member.first_name, grade: @member.grade, graduated_year: @member.graduated_year, last_name: @member.last_name, student_number: @member.student_number, title: @member.title } }
    assert_redirected_to members_path
  end

  test "should destroy member" do
    assert_difference('Member.count', -1) do
      delete member_url(@member)
    end

    assert_redirected_to members_path
  end
end
