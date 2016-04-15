require 'rest-client'

class FetchTeamStatsJob < ActiveJob::Base
  queue_as :urgent

  def perform(*args)
    teams = Hash.new

    fetch_vex_worlds_teams().each_with_index do |raw_team, index|
        teams[raw_team["number"]] = raw_team.merge({"robot_score" => 0, "robot_rank" => 500, "programming_score" => 0, "programming_rank" => 500, "actual_order" => index})
    end
    logger.info "Fetched #{teams.count} teams from vexdb.io"

    fetch_top_500_robot_skills().each do |result|
      team_number = result["team"]
      if teams.key? team_number
        team = teams[team_number]

        team["robot_score"] = result["score"]
        team["robot_rank"] = result["season_rank"]
      end
    end
    logger.info "Successfully fetched top 500 robot skills teams from vexdb.io"

    fetch_top_500_programming_skills().each do |result|
      team_number = result["team"]
      if teams.key? team_number
        team = teams[team_number]

        team["programming_score"] = result["score"]
        team["programming_rank"] = result["season_rank"]
      end
    end
    logger.info "Successfully fetched top 500 programming skills teams from vexdb.io"

    ActiveRecord::Base.logger.silence do
      TeamStat.update_all(actual_order: nil)
      teams.each do |team_number, raw_team|
        team = TeamStat.find_or_create_by(number: raw_team["number"])

        team.team_name = raw_team["team_name"]

        team.robot_score = raw_team["robot_score"]
        team.robot_rank = raw_team["robot_rank"]
        team.programming_score = raw_team["programming_score"]
        team.programming_rank = raw_team["programming_rank"]

        team.country = raw_team["country"]
        team.city = raw_team["city"]
        team.region = raw_team["region"]

        team.actual_order = raw_team["actual_order"]

        team.save
      end
    end

    nil
  end

private
  def fetch_vex_worlds_teams
    # 2016 VEX Worlds - VEX Robotics Competition High School Division
    # http://vexdb.io/events/view/RE-VRC-16-3279
    vex_worlds_sku = "RE-VRC-16-3279"

    response = RestClient.get "http://api.vexdb.io/v1/get_teams",
    { params:
        { sku: vex_worlds_sku }
    }

    # Eusure HTTP request is successed
    return [] unless response.code == 200

    json = JSON.parse(response)

    if json["status"] == 1
        return json["result"]
    else
        return []
    end
  end

  def fetch_top_skills(type)
    response = RestClient.get "http://api.vexdb.io/v1/get_skills",
    { params:
       {
         program: "VRC",
         type: type,
         season: "Nothing But Net",
         season_rank: "true",
         limit_number: "500"
       }
    }

    # Eusure HTTP request is successed
    return [] unless response.code == 200

    json = JSON.parse(response)

    if json["status"] == 1
       return json["result"]
    else
       return []
    end
  end

  def fetch_top_500_robot_skills
    return fetch_top_skills("0")
  end

  def fetch_top_500_programming_skills
    return fetch_top_skills("1")
  end
end
