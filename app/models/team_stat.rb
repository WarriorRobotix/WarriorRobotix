class TeamStat < ActiveRecord::Base
  belongs_to :division
  has_many :scouting_entries
end
