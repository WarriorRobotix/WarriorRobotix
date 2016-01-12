class PhotoLocation < ApplicationRecord
  belongs_to :photo, inverse_of: :photo_locations
  belongs_to :processed_photo, class_name: 'Photo', inverse_of: :photo_locations

  enum dimension_restriction: [:restrict_none, :restrict_ratio, :restrict_dimension]

  validates :page, presence: true
  validates :location, presence: true
  validate :correct_dimension

  private
  def correct_dimension
    #pass
  end
end
