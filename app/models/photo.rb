class Photo < ActiveRecord::Base
  mount_uploader :file, PhotoUploader

  has_many :photo_locations, inverse_of: [:photo, :processed_photo]
end
