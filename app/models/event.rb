class Event < Post
  has_many :attendances

  validates :start_at, presence: true
  validates :end_at, presence: true
  validate :end_after_start

  def update_reply(member, reply)
    reply = reply.to_s.downcase

    return if member.nil? || !['confirmed', 'maybe', 'declined'].include?(reply) || (self.restriction_value > member.max_restriction)

    attendance = Attendance.find_or_initialize_by(member: member, event: self)

    attendance.reply = reply

    attendance.save
  end

  def reply_from(member)
    return if member.nil?
    reply = Attendance.find_by(member: member, event: self).try(:reply)
    if ['confirmed', 'maybe', 'declined'].include? reply
      reply
    else
      nil
    end
  end

  def end_after_start
    if start_at.present? && end_at.present? && (start_at > end_at)
      errors.add(:end_at, "must after start at")
    end
  end
end
