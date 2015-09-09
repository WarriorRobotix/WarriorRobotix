class Post < ActiveRecord::Base
  belongs_to :author, class_name: "Member", :foreign_key => "author_id"

  enum restriction: [:everyone, :member, :admin]

  validates :restriction, presence: true

  validates :title, presence: true
  validates :description, presence: true

  def self.valid_restrictions
    restrictions
  end

  def email_notification
    @email_notification ||= false
  end

  def email_notification=(val)
    if val.is_a? String
      val = (val =~ (/^(true|t|yes|y|1)$/i)) ? true : false
    else
      val = (val == true)
    end
    @email_notification = val
  end
end
