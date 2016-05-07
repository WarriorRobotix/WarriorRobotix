class Attendance < ActiveRecord::Base
  enum status: [:invited, :attending, :attended]
  enum reply: [:no_reply, :confirmed, :maybe, :declined]

  validate :end_at_after_start_at

  belongs_to :member, touch: true
  belongs_to :event, touch: true

  before_save :recalculate_duration

  private
  def end_at_after_start_at
    if start_at.present? && end_at.present? && (start_at > end_at)
      errors.add(:end_at, "must after start at")
    end
  end

  def recalculate_duration
    if start_at_changed? || end_at_changed? || status_changed?
      if attended? && start_at != nil && end_at != nil
        self.duration_float = (end_at - start_at) / 3600.0
      else
        self.duration_float = 0.0
      end
    end
  end
end
