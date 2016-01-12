class Sponsor < ApplicationRecord
  validates :name, presence: true
  validates :description, presence: true
  validates :image_link, presence: true
end
