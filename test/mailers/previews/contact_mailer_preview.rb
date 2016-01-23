# Preview all emails at http://localhost:3000/rails/mailers/contact_mailer
class ContactMailerPreview < ActionMailer::Preview
  def contact_us_email
    message = {full_name: 'Test Subject', email: 'test@example.com', phone_number: '(555)555-5555', body: 'This is a contact us message', ip: '192.168.1.1', timestamp: Time.zone.now.to_s}
    ContactMailer.contact_us_email(message)
  end

  def forwarding_email
    email = {from: 'test@example.com', to: {full: 'Warrior Robotix <email@4659warriors.com>', email: 'email@4659warriors.com'}, subject: 'Test Forwarding', body: 'This is the test email\'s body' }
    attachments = []
    ContactMailer.forwarding_email(email, attachments)
  end
end
