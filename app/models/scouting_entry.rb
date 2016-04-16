class ScoutingEntry < ActiveRecord::Base
  belongs_to :team_stat
  belongs_to :member
end
