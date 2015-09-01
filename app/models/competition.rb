class Competition < ActiveRecord::Base
  validates :name, presence: true
  validates :cover_image_link, presence: true
  before_validation :nullify_blanks

  private
  def nullify_blanks
    self.description = nil if self.description.blank?
    self.location = nil if self.location.blank?
    self.achievements = nil if self.achievements.blank?
  end
end
