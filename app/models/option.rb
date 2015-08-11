class Option < ActiveRecord::Base
  belongs_to :poll
  has_many :ballots, dependent: :destroy
  has_many :members, through: :ballots
end
