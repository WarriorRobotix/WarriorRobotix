class MemberMailer < ApplicationMailer
  def reset_password_email(member, reset_password_token)
    @member = member
    @member.reset_password_token ||= reset_password_token
    mail(to: @member.email, subject: 'Reset password')
  end

  def welcome_email(member, reset_password_token)
    @member = member
    @member.reset_password_token ||= reset_password_token
    mail(to: @member.email, subject: 'Welcome to Warrior Robotix')
  end

  def registration_rejected_email(member, reason=nil)
    @member = member
    @reason = reason
    mail(to: @member.email, subject: 'Your Warrior Robotix registration application has rejected')
  end
end
