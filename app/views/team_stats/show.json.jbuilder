json.extract! @team_stat, :id, :number, :team_name, :robot_score, :robot_rank, :programming_score, :programming_rank, :country, :city, :region, :division_id, :created_at, :updated_at
json.division_name @team_stat.division&.name
