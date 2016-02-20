class Team < ActiveRecord::Base
  has_and_belongs_to_many :posts, touch: true
  has_many :members
end
