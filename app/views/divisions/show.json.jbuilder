json.extract! @division, :id, :name, :created_at, :updated_at
json.teams do
  json.array!(@division.team_stats.order(:actual_order).all) do |team_stat|
    json.extract! team_stat, :id, :number, :team_name, :robot_score, :robot_rank, :programming_score, :programming_rank, :country, :city, :region, :division_id, :actual_order, :created_at, :updated_at
    json.division_name @division.name
  end
end
