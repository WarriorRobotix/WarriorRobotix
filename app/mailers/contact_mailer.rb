class ContactMailer < ApplicationMailer
  default :from => "contact-us@4659warriors.com"
  def contact_us_email(message)
    @message = message
    mail(to: 'team4659@gmail.com', subject: "Contact-us message from: #{@message[:full_name]}")
  end
end
