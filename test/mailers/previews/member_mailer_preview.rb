# Preview all emails at http://localhost:3000/rails/mailers/member_mailer
class MemberMailerPreview < ActionMailer::Preview
  def reset_password_email
    member = Member.last
    member.reset_password_token = SecureRandom.hex
    MemberMailer.reset_password_email(member)
  end

  def welcome_email
    member = Member.last
    member.reset_password_token = SecureRandom.hex
    MemberMailer.welcome_email(member)
  end

  def registration_rejected_email
    MemberMailer.registration_rejected_email(Member.last)
  end
end
