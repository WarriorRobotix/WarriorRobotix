class EmailProcessor
  def initialize(email)
    @email = email
  end

  def process
    email_hash = {from: @email.from, to: {full: @email.to[:full], email: @email.to[:email]}, subject: @email.subject, body: @email.body}
    ContactMailer.forwarding_email(email_hash, @email.attachments)
  end
end
