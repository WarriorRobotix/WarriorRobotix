require 'test_helper'

class SponsorsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @sponsor = sponsors(:one)
    sign_in_as_admin
  end

  test "should get index" do
    get sponsors_url
    assert_response :success
  end

  test "should get new" do
    get new_sponsor_url
    assert_response :success
  end

  test "should create sponsor" do
    assert_difference('Sponsor.count') do
      post sponsors_url, params: { sponsor: { description: @sponsor.description, facebook_link: @sponsor.facebook_link, image_link: @sponsor.image_link, name: @sponsor.name, twitter_link: @sponsor.twitter_link, website_link: @sponsor.website_link } }
    end

    assert_redirected_to sponsors_path
  end

  test "shouldn't show single sponsor" do
    assert_raises(ActionController::RoutingError) do
      get sponsor_url(@sponsor)
    end
  end

  test "should get edit" do
    get edit_sponsor_url(@sponsor)
    assert_response :success
  end

  test "should update sponsor" do
    patch sponsor_url(@sponsor), params: { sponsor: { description: @sponsor.description, facebook_link: @sponsor.facebook_link, image_link: @sponsor.image_link, name: @sponsor.name, twitter_link: @sponsor.twitter_link, website_link: @sponsor.website_link } }
    assert_redirected_to sponsors_path
  end

  test "should destroy sponsor" do
    assert_difference('Sponsor.count', -1) do
      delete sponsor_url(@sponsor)
    end

    assert_redirected_to sponsors_path
  end
end
