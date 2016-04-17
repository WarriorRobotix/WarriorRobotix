class ScoutingEntry < ActiveRecord::Base
  belongs_to :team_stat
  belongs_to :member

  validates :team_stat, presence: true
  validates :member, presence: true
end
