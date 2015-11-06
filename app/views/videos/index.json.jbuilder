json.array!(@videos) do |video|
  json.extract! video, :id, :title, :youtube_vid, :author, :upload_date
  json.url video_url(video, format: :json)
end
