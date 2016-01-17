require 'test_helper'

class RegistrationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    sign_in_as_admin

    RegistrationField.destroy_all
    post fix_registration_fields_url

    post registration_toggle_url, params: { closed: "0" }
  end

  test "should get form" do
    get register_url
    assert_response :success
  end

  test "should submit form" do
    assert_difference "Member.unscoped.where(accepted: false).count" do
      post register_url, params: { form: { "First name" => "Test", "Last name" => "Example", "Email" => "test@example.com", "Student number" => "999", "Grade" => "9", "allow_emails" => "1", "agree_contract" => "1" } }
    end
    assert_response :success
  end

  test "shouldn't submit form without allowing email or agreeing contract" do
    assert_no_difference "Member.unscoped.where(accepted: false).count" do
      post register_url, params: { form: { "First name" => "Test", "Last name" => "Example", "Email" => "test@example.com", "Student number" => "999", "Grade" => "9", "allow_emails" => "0", "agree_contract" => "0" } }
    end
    assert_response :success
  end
end
