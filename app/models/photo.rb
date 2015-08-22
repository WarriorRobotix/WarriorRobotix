class Photo < ActiveRecord::Base
  mount_uploader :file, PhotoUploader

  has_many :photo_locations, inverse_of: [:photo, :processed_photo]

  validate :at_least_one_source

  private
  def at_least_one_source
    errors.add(:base, 'At least one source must be provided') unless self.file.present? || self.external_link.present?
  end
end
