class PhotoLocation < ActiveRecord::Base
  belongs_to :photo, inverse_of: :photo_locations
  belongs_to :processed_photo, class_name: 'Photo', inverse_of: :photo_locations
end
