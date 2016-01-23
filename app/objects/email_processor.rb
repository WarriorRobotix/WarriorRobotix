class EmailProcessor
  def initialize(email)
    @email = email
  end

  def process
    email_hash = {from: @email.from[:full], to: @email.to, subject: @email.subject, body: @email.body, timestamp: Time.zone.now.to_s}
    attachments = @email.attachments.map do |att|
      {filename: att.original_filename, data: File.read(att.tempfile)}
    end
    ContactMailer.forwarding_email(email_hash, attachments).deliver_later
  end
end
