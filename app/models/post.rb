class Post < ActiveRecord::Base
  belongs_to :member
  belongs_to :attachment

  enum restriction: [:everyone, :member, :admin]

  validates :restriction, presence: true

  validates :title, presence: true
  validates :description, presence: true
end
