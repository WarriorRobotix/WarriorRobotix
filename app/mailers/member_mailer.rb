class MemberMailer < ApplicationMailer
  def reset_password_email(member)
    @member = member
    mail(to: @member.email, subject: 'Reset password')
  end
end
