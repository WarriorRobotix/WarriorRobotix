class Post < ApplicationRecord
  belongs_to :author, class_name: "Member", :foreign_key => "author_id"
  has_and_belongs_to_many :teams

  enum restriction: [:everyone, :member, :limited, :admin]

  validates :restriction, presence: true

  validates :title, presence: true
  validates :description, presence: true

  before_save :remove_useless_limited_teams

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

  def add_limited_teams(teams)
    teams.each do |t|
      if team = Team.find_by(id: t.to_i)
        self.teams << team
      end
    end
  end

  def audience_description
    case self.restriction
    when "everyone"
      self.restriction.capitalize
    when "limited"
      teams_description = self.teams.all.order(:name).pluck(:name).join(', ')
      teams_description = "Limited (ADMIN ONLY)" if teams_description.blank?
      teams_description
    else
      self.restriction.pluralize.capitalize
    end
  end

  def restriction_value
    Post.restrictions[self.restriction]
  end

  private
  def remove_useless_limited_teams
    if self.restriction_changed? && self.restriction_was == "limited"
      self.teams.clear
    end
    true
  end
end
