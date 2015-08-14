class Ballot < ActiveRecord::Base
  belongs_to :member
  belongs_to :option, counter_cache: true, touch: true
end
