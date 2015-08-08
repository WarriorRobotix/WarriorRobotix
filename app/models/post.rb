class Post < ActiveRecord::Base
  belongs_to :author, class_name: "Member", :foreign_key => "author_id"
  belongs_to :attachment, polymorphic: true

  enum restriction: [:everyone, :member, :admin]

  validates :restriction, presence: true

  validates :title, presence: true
  validates :description, presence: true

  def type_name
    attachment.nil? ? "Post" : attachment.class.name
  end
end
