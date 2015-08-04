class Event < ActiveRecord::Base
  has_one :post, as: :attachment
end
