# Preview all emails at http://localhost:3000/rails/mailers/member_mailer
class MemberMailerPreview < ActionMailer::Preview
  def reset_password_email
    member = Member.last
    member.reset_password_token = SecureRandom.urlsafe_base64(6)
    MemberMailer.reset_password_email(member, member.reset_password_token)
  end

  def welcome_email
    member = Member.last
    member.reset_password_token = SecureRandom.urlsafe_base64(6)
    MemberMailer.welcome_email(member, member.reset_password_token)
  end

  def registration_rejected_email
    member = Member.last
    MemberMailer.registration_rejected_email(member.full_name, member.email, "Your answers are too short")
  end

  def registration_rejected_without_reason_email
    member = Member.last
    MemberMailer.registration_rejected_email(member.full_name, member.email, nil)
  end
end
