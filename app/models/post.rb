class Post < ActiveRecord::Base
  belongs_to :author, class_name: "Member", :foreign_key => "author_id"

  enum restriction: [:everyone, :member, :admin]

  validates :restriction, presence: true

  validates :title, presence: true
  validates :description, presence: true
end
