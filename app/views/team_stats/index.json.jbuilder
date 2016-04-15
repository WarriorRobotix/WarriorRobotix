json.array!(@team_stats) do |team_stat|
  json.extract! team_stat, :id, :number, :team_name, :robot_score, :robot_rank, :programming_score, :programming_rank, :country, :city, :region, :division_id
  json.extract! team_stat.division, :name
end
