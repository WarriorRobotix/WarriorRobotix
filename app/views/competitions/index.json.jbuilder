json.array!(@competitions) do |competition|
  json.extract! competition, :id, :name, :description, :location, :achievements, :cover_image_link, :start_date, :end_date
  json.url competition_url(competition, format: :json)
end
