class Event < Post
  has_many :attendances

  def update_reply(member, reply)
    reply = reply.to_s.downcase

    return if member.nil? || !['confirmed', 'maybe', 'declined'].include?(reply) || (self[:restriction] > member.max_restriction)

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

  def confirmed
    attendances.where(reply: 1)
  end

  def maybe
    attendances.where(reply: 2)
  end

  def declined
    attendances.where(reply: 3)
  end
end
