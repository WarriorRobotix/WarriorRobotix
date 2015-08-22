class PhotoLocation < ActiveRecord::Base
  belongs_to :photo
  belongs_to :processed_photo
end
