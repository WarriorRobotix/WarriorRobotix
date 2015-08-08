class Attendance < ActiveRecord::Base
  enum status: [:invited, :attending, :attended, :skipped]
  enum reply: [:no_reply, :confirmed, :maybe, :declined]

  validate :end_at_after_start_at
  validate :attended_requirements

  attr_accessor :skip_end_at

  after_initialize :set_skip_end_at
  before_validation :set_skipped_end_at_nil

  belongs_to :member
  belongs_to :event

  private
  def set_skip_end_at
    # Set to not skip if it is a new record
    # Set to true on nil end_at otherwise
    if self.skip_end_at.nil?
      self.skip_end_at = new_record? ? false : self.end_at.nil?
    end
  end

  def set_skipped_end_at_nil
    self.end_at = nil if (self.skip_end_at == true || self.skip_end_at == "1")
  end

  def end_at_after_start_at
    if start_at.present? && end_at.present? && (start_at > end_at)
      errors.add(:end_at, "must after start at")
    end
  end

  def attended_requirements
    if start_at.present? && end_at.present?
      errors.add(:end_at, "must after start at")
    end
  end
end
