class Video < ActiveRecord::Base
  validates :title, presence: true
  validates :youtube_vid, presence: true
  validates :upload_date, presence: true
end
