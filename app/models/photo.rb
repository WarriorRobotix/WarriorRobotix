class Photo < ActiveRecord::Base
  mount_uploader :file, PhotoUploader
  attr_accessor :original_filename

  has_many :photo_locations, inverse_of: [:photo, :processed_photo]
  before_create :set_default_name

  validate :at_least_one_source

  def path
    if file.present?
      file.url
    elsif external_link.present?
      external_link
    end
  end

  private
  def at_least_one_source
    errors.add(:base, 'At least one source must be provided') unless self.file.present? || self.external_link.present?
  end

  def external_link_file_extension
    ext = /\.([^\.\?]+)(?:\?[^\?]*)?$/.match(file.original_name)[1]
    unless ['jpeg', 'jpg', 'png', 'gif'].include? ext
      errors.add(:external_link, "isn't a jpeg, jpg, png or gif photo")
    end
  end

  def set_default_name
    if self.name.blank?
      if self.file.present? && self.original_filename.present?
        self.name = self.original_filename.gsub(/\.[^\.]+$/, "")
      elsif self.external_link.present?
        self.name = /\/([^\/\.]+)(?:\..[^\.\/]+)?(?:\?[^\?\/]+)?$/.match(self.external_link)[1]
      end
    end
  end
end
