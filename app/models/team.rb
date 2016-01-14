class Team < ApplicationRecord
  has_and_belongs_to_many :posts
  has_many :members
end
