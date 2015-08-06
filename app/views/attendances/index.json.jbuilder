json.array!(@attendances) do |attendance|
  json.extract! attendance, :id, :start_at, :end_at
  json.url attendance_url(attendance, format: :json)
end
