class Ballot < ApplicationRecord
  belongs_to :member
  belongs_to :option, counter_cache: true, touch: true
end
