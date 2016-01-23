class ContactMailer < ApplicationMailer
  default :from => "Contact Us 4659WARRIORS.COM <contact-us@4659warriors.com>"
  def contact_us_email(message)
    @message = message
    mail(to: ENV['FORWARD_EMAIL_TO_ADDRESS'], subject: "Contact-us message from: #{@message[:full_name]}")
  end

  def forwarding_email(email, original_attachments)
    @email = email
    original_attachments.each do |original_att|
      attachments[original_att.original_filename] = File.read(original_att.tempfile)
    end
    mail(to: ENV['FORWARD_EMAIL_TO_ADDRESS'], from: "Forward 4659WARRIORS.COM <forward@4659warriors.com>", subject: "#{@email[:to][0][:email]} forward: #{@email[:subject]}")
  end
end
