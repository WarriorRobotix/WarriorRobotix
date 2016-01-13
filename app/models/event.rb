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

  def replyers_description(reply)
    reply_id = Attendance.replies[reply]
    reply_count = self.attendances.where(reply: reply_id).count
    names = Member.joins(:attendances).where(attendances: {event_id: self.id, reply: reply_id }).limit(4).pluck(:first_name, :last_name).map {|names| names.join(' ')}
    if reply_count == 0
      "0 members"
    elsif reply_count == 1
      "1 member - #{names[0]}"
    elsif reply_count <= 4
      "#{reply_count} members - #{names.join(', ')}"
    else
      "#{reply_count} members - #{names[0..2].join(', ')} and others"
    end
  end

  def end_after_start
    if start_at.present? && end_at.present? && (start_at > end_at)
      errors.add(:end_at, "must after start at")
    end
  end
end
