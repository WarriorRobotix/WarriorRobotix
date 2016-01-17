require 'test_helper'

class VideosControllerTest < ActionDispatch::IntegrationTest
  setup do
    @video = videos(:one)
    sign_in_as_admin
  end

  test "should get index" do
    get videos_url
    assert_response :success
  end

  test "should get new" do
    get new_video_url
    assert_response :success
  end

  test "should create video" do
    assert_difference('Video.count') do
      post videos_url, params: { video: { author: @video.author, title: @video.title, upload_date: @video.upload_date, youtube_vid: @video.youtube_vid } }
    end

    assert_redirected_to videos_url
  end

  test "shouldn't create video with errors" do
    assert_no_difference('Video.count') do
      post videos_url, params: { video: { upload_date: @video.upload_date } }
    end

    assert_response :success
  end

  test "shouldn't show single video" do
    #The only way to view video should be Videos#index
    assert_raises(ActionController::RoutingError) do
      get video_url(@video)
    end
  end

  test "should get edit" do
    get edit_video_url(@video)
    assert_response :success
  end

  test "should update video" do
    patch video_url(@video), params: { video: { author: @video.author, title: @video.title, upload_date: @video.upload_date, youtube_vid: @video.youtube_vid } }
    assert_redirected_to videos_url
  end

  test "shouldn't update video with errors" do
    last_updated_at = @video.updated_at
    patch video_url(@video), params: { video: { title: nil } }
    
    assert_equal last_updated_at, @video.updated_at
    assert_response :success
  end

  test "should destroy video" do
    assert_difference('Video.count', -1) do
      delete video_url(@video)
    end

    assert_redirected_to videos_path
  end
end
