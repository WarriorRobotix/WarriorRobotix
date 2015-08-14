require 'test_helper'

class RegistrationFieldsControllerTest < ActionController::TestCase
  setup do
    @registration_field = registration_fields(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:registration_fields)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create registration_field" do
    assert_difference('RegistrationField.count') do
      post :create, registration_field: { map_to_model: @registration_field.map_to_model, name: @registration_field.name }
    end

    assert_redirected_to registration_field_path(assigns(:registration_field))
  end

  test "should show registration_field" do
    get :show, id: @registration_field
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @registration_field
    assert_response :success
  end

  test "should update registration_field" do
    patch :update, id: @registration_field, registration_field: { map_to_model: @registration_field.map_to_model, name: @registration_field.name }
    assert_redirected_to registration_field_path(assigns(:registration_field))
  end

  test "should destroy registration_field" do
    assert_difference('RegistrationField.count', -1) do
      delete :destroy, id: @registration_field
    end

    assert_redirected_to registration_fields_path
  end
end
