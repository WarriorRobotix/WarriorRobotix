class ContactMailer < ApplicationMailer
  default :from => "contact-us@4659warriors.com"
  def contact_us_email(message)
    @message = message
    mail(to: 'team4659.website@gmail.com', subject: 'A new contact us message')
  end
end
