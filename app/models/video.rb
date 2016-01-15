class Video < ApplicationRecord
  validates :title, presence: true
  validates :youtube_vid, presence: true
  validates :upload_date, presence: true

  def youtube_vid=(value)
    if /(?:v=|be\/)(?<vid>[A-Za-z0-9_\-]+)/ =~ value.to_s
      super(Regexp.last_match(:vid))
    else
      super(value)
    end
  end
end
