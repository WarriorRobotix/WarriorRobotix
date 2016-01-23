class ContactMailer < ApplicationMailer
  default :from => "Contact Us - Website <contact-us@4659warriors.com>"
  def contact_us_email(message)
    @message = message
    mail(to: ENV['FORWARD_EMAIL_TO_ADDRESS'], subject: "Contact-us message from: #{@message[:full_name]}")
  end

  def forwarding_email(email, original_attachments)
    @email = email
    original_attachments.each do |original_att|
      attachments[original_att[:filename]] = original_att[:data]
    end
    mail(to: ENV['FORWARD_EMAIL_TO_ADDRESS'], from: "Forward - Website <forward@4659warriors.com>", subject: "#{@email[:to][0][:email]} forward: #{@email[:subject]}")
  end
end
