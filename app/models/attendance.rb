class Attendance < ActiveRecord::Base
  enum status: [:invited, :attending, :attended]
  enum reply: [:no_reply, :confirmed, :maybe, :declined]

  validate :end_at_after_start_at

  belongs_to :member
  belongs_to :event, touch: true

  private
  def end_at_after_start_at
    if start_at.present? && end_at.present? && (start_at > end_at)
      errors.add(:end_at, "must after start at")
    end
  end
end
