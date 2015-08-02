class Post < ActiveRecord::Base
  belongs_to :member

  enum restriction: [:everyone, :member, :admin]
  enum attachment_type: [:none, :event, :poll]
end
