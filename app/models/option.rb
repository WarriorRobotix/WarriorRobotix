class Option < ActiveRecord::Base
  belongs_to :poll
  has_many :ballots
  has_many :members, through: :ballots
end
