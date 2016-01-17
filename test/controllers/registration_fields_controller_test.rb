require 'test_helper'

class RegistrationFieldsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @registration_field = registration_fields(:one)
    sign_in_as_admin
  end

  test "should get index" do
    get registration_fields_url
    assert_response :success
  end

  test "should get new" do
    get new_registration_field_url
    assert_response :success
  end

  test "should create registration_field" do
    assert_difference('RegistrationField.count') do
      post registration_fields_url, params: { registration_field: { title: "What's your favorite complier?", input_type: @registration_field.input_type, optional: @registration_field.optional  } }
    end

    assert_redirected_to registration_fields_url
  end

  test "shouldn't create registration_field with errors" do
    assert_no_difference('RegistrationField.count') do
      post registration_fields_url, params: { registration_field: { optional: @registration_field.optional } }
    end

    assert_response :success
  end

  test "shouldn't show single registration_field" do
    #The only way to view registration_field should be RegistrationFields#index
    assert_raises(ActionController::RoutingError) do
      get registration_field_url(@registration_field)
    end
  end

  test "should get edit" do
    get edit_registration_field_url(@registration_field)
    assert_response :success
  end

  test "should update registration_field" do
    patch registration_field_url(@registration_field), params: { registration_field: { title: @registration_field.title, input_type: @registration_field.input_type, optional: @registration_field.optional  } }
    assert_redirected_to registration_fields_url
  end

  test "shouldn't update registration_field with errors" do
    last_updated_at = @registration_field.updated_at
    patch registration_field_url(@registration_field), params: { registration_field: { title: nil } }

    assert_equal last_updated_at, @registration_field.updated_at
    assert_response :success
  end

  test "should destroy registration_field" do
    assert_difference('RegistrationField.count', -1) do
      delete registration_field_url(@registration_field)
    end

    assert_redirected_to registration_fields_path
  end

  test "should automatically fix the registration fields configuration" do
    assert_difference('RegistrationField.count', 5) do
      post fix_registration_fields_url
    end

    assert_redirected_to registration_fields_path
  end

  test "show move a registration field up" do
    RegistrationField.destroy_all
    post fix_registration_fields_url

    first_id = RegistrationField.order(order: :ASC).first.id
    assert_no_difference "RegistrationField.find(#{first_id}).order" do
      post registration_field_up_url(first_id)
    end
    assert_redirected_to registration_fields_url

    last_id = RegistrationField.order(order: :ASC).last.id
    assert_difference "RegistrationField.find(#{last_id}).order", -1 do
      post registration_field_up_url(last_id)
    end
    assert_redirected_to registration_fields_url
  end

  test "show move a registration field down" do
    RegistrationField.destroy_all
    post fix_registration_fields_url

    first_id = RegistrationField.order(order: :ASC).first.id
    assert_difference "RegistrationField.find(#{first_id}).order", 1 do
      post registration_field_down_url(first_id)
    end
    assert_redirected_to registration_fields_url

    last_id = RegistrationField.order(order: :ASC).last.id
    assert_no_difference "RegistrationField.find(#{last_id}).order" do
      post registration_field_down_url(last_id)
    end
    assert_redirected_to registration_fields_url
  end

end
