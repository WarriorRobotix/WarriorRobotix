# Preview all emails at http://localhost:3000/rails/mailers/member_mailer
class MemberMailerPreview < ActionMailer::Preview
  def reset_password_email
    MemberMailer.reset_password_email(Member.last)
  end
end
