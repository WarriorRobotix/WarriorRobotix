class Option < ApplicationRecord
  belongs_to :poll, touch: true
  has_many :ballots, dependent: :destroy
  has_many :members, through: :ballots
end
