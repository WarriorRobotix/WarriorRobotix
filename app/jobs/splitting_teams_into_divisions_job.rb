class SplittingTeamsIntoDivisionsJob < ActiveJob::Base
  queue_as :urgent

  def perform(*args)
    divisions = Division.order(id: :ASC).all.pluck(:id)
    return if divisions.empty?

    teams = TeamStat.where.not(actual_order: nil).order(actual_order: :ASC).all

    index = 0
    division_count = divisions.count

    ActiveRecord::Base.logger.silence do
      teams.each do |team|
        team.division_id = divisions[index]
        team.save

        index = (index + 1) % division_count
      end
    end
    
    nil
  end
end
