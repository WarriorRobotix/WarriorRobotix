require 'test_helper'

class VideoTest < ActiveSupport::TestCase
  test "video should accept youtube ID" do
     video = Video.new(youtube_vid: "ZtGAtP-YmeQ")
     assert_equal("ZtGAtP-YmeQ", video.youtube_vid)
  end

  test "video should accept youtube.com link" do
     video = Video.new(youtube_vid: "https://www.youtube.com/watch?v=ZtGAtP-YmeQ")
     assert_equal("ZtGAtP-YmeQ", video.youtube_vid)
  end

  test "video should accept youtu.be link" do
     video = Video.new(youtube_vid: "https://youtu.be/ZtGAtP-YmeQ")
     assert_equal("ZtGAtP-YmeQ", video.youtube_vid)
  end

  test "video should accept youtube.com link without https" do
     video = Video.new(youtube_vid: "www.youtube.com/watch?v=ZtGAtP-YmeQ")
     assert_equal("ZtGAtP-YmeQ", video.youtube_vid)
  end
end
