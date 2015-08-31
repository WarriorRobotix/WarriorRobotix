class Competition < ActiveRecord::Base
  validates :name, presence: true
  validates :cover_image_link, presence: true
end
